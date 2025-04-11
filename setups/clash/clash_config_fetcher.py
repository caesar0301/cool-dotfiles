#!/usr/bin/env python3
from yaml import load, dump, safe_load
from yaml import Loader
import copy
import urllib.request
import time
import argparse

default_match_direct = False
add_country_groups = False
add_gfwlist = False


# Remote configs
def read_remote_config(link):
    if not link:
        return None
    req = urllib.request.Request(link)
    req.add_header(
        "User-Agent",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.69",
    )
    with urllib.request.urlopen(req) as f:
        return load(f, Loader)


# Assemble proxy group configs
def create_proxy_group(
    name,
    proxy_configs,
    extra_names=list(),
    type="select",
    url="http://www.gstatic.com/generate_204",
    interval=300,
):
    new_group = {"name": name, "type": type, "proxies": list()}
    if type == "url-test":
        new_group["interval"] = interval
        new_group["url"] = url

    proxy_names = [i["name"] for i in proxy_configs]
    new_group["proxies"] = extra_names + proxy_names
    return new_group


def rule_key(rule):
    parts = rule.split(",")
    if len(parts) < 3:
        return (parts[0], "")
    else:
        return (parts[0], parts[2])


def gfwrules():
    rules = list()
    with open("rules/gfwrules.txt") as ifile:
        for line in ifile:
            if line.startswith("#"):
                continue
            rules.append(line.strip("\r\n "))
    return rules


def read_ruleset_as_providers(result):
    filename = "rule_providers.yaml"
    ruleset = dict()
    with open(filename) as ifile:
        try:
            ruleset = safe_load(ifile)
        except yaml.YAMLError as ex:
            print(ex)
    providers = ruleset.get("rule-providers", [])
    result["rule-providers"] = providers
    print(providers)
    for provider in providers:
        result["rules"].append("RULE-SET,%s,Proxy" % provider)
    return result


def read_ruleset_as_rules(result):
    onlyfiles = ["ChatGPT.yaml", "cdn.yaml", "news.yaml", "oracle.yaml"]
    for fname in onlyfiles:
        extra_rules = dict()
        with open("ruleset/" + fname) as ifile:
            try:
                extra_rules = safe_load(ifile)
            except yaml.YAMLError as ex:
                print(ex)
        if "payload" not in extra_rules:
            continue
        for rule in extra_rules["payload"]:
            if "IP-CIDR" in rule:
                continue
            result["rules"].append("%s,Proxy" % rule)
    return result


def add_group(target, new_group):
    groups = target.get("proxy-groups", [])
    group_name = new_group["name"]
    found = False
    for i in range(0, len(groups)):
        if groups[i]["name"] == group_name:
            groups[i] = new_group
            found = True
            break
    if not found:
        groups.append(new_group)
    target["proxy-groups"] = groups


def finalize_rules(trojan):
    rules = copy.deepcopy(trojan["rules"])
    if add_gfwlist:
        rules = set(rules + gfwrules())
    res = sorted([i for i in set(rules) if not i.startswith("MATCH,")])
    if default_match_direct:
        res.append("MATCH,DIRECT")
    else:
        res.append("MATCH,Proxy")
    trojan["rules"] = res


def finalize_groups(result):
    # selected proxies
    selected_proxies = []
    selected_countries = ["美国", "日本", "香港", "新加坡", "澳大利亚"]
    for cname in selected_countries:
        selected_proxies += [i for i in result["proxies"] if cname in i["name"]]
    result["proxies"] = selected_proxies

    # unified group, required by client
    auto_group = create_proxy_group(
        name="Auto", proxy_configs=result["proxies"], type="url-test"
    )
    add_group(result, auto_group)

    group_names = ["Auto"]

    # selected country groups
    if add_country_groups:
        country_groups = {"美国": "AutoUS", "日本": "AutoJP"}
        for cname in country_groups:
            cproxies = [i for i in result["proxies"] if cname in i["name"]]
            cgroup = create_proxy_group(
                name=country_groups[cname], proxy_configs=cproxies, type="url-test"
            )
            add_group(result, cgroup)
        group_names += list(country_groups.values())

    merged_group = create_proxy_group(
        name="Proxy",
        proxy_configs=result["proxies"],
        type="select",
        extra_names=group_names,
    )
    add_group(result, merged_group)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="ClashConfigFetcher")
    parser.add_argument("-t", "--trojan", type=str, help="Trojan registration link")
    parser.add_argument(
        "-r", "--rulesets", action="store_true", help="Add ruleset (default false)"
    )
    parser.add_argument(
        "-p",
        "--providers",
        action="store_true",
        help="Add ruleset as providers (default false)",
    )
    parser.add_argument(
        "-d",
        "--default-direct",
        action="store_true",
        help="Add default MATCH as DIRECT (default false)",
    )
    parser.add_argument(
        "-g",
        "--groups",
        action="store_true",
        help="Add country wise groups (default false)",
    )
    parser.add_argument(
        "-w", "--gfwlist", action="store_true", help="Add gfwlist rules (default false)"
    )
    args = parser.parse_args()
    if not args.trojan:
        raise RuntimeError("--trojan argument should be set")

    add_country_groups = args.groups
    default_match_direct = args.default_direct
    add_gfwlist = args.gfwlist

    # load remote policies
    trojan = read_remote_config(args.trojan)
    if trojan is None:
        raise RuntimeError("unexpected None remote trojan config")

    trojan["secret"] = "canyoukissme"
    trojan["proxy-groups"] = list()

    if args.providers:
        read_ruleset_as_providers(trojan)
    if args.rulesets:
        read_ruleset_as_rules(trojan)

    finalize_rules(trojan)
    finalize_groups(trojan)

    # write out to file
    ofile = "config.%s" % time.strftime("%Y%m%d")
    with open(ofile, "w") as ofile:
        dump(trojan, ofile)
