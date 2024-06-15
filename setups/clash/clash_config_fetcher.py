#!/usr/bin/env python3
from yaml import load, dump, safe_load
from yaml import Loader, Dumper
import copy
import urllib.request
import os
import time


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


def finalize_rules(rules):
    gfwr = gfwrules()
    allrules = set(rules + gfwr)
    res = sorted([i for i in set(allrules) if not i.startswith("MATCH,")])
    res.append("MATCH,DIRECT")
    return res


def finalize_groups(result):
    # selected proxies
    selected_proxies = []
    selected_countries = ["美国", "日本"]
    for cname in selected_countries:
        selected_proxies += [i for i in result["proxies"] if cname in i["name"]]
    result["proxies"] = selected_proxies

    # unified group, required by client
    auto_group = create_proxy_group(
        name="Auto", proxy_configs=result["proxies"], type="url-test"
    )
    add_group(result, auto_group)

    # selected country groups
    country_groups = {"美国": "AutoUS", "日本": "AutoJP"}
    for cname in country_groups:
        cproxies = [i for i in result["proxies"] if cname in i["name"]]
        cgroup = create_proxy_group(
            name=country_groups[cname], proxy_configs=cproxies, type="url-test"
        )
        add_group(result, cgroup)

    manual_group = create_proxy_group(
        name="Proxy",
        proxy_configs=result["proxies"],
        type="select",
        extra_names=["Auto"] + list(country_groups.values()),
    )
    add_group(result, manual_group)
    return result


def finalize(trojan, v2ss):
    if trojan is not None and v2ss is None:
        final = trojan
    elif trojan is None and v2ss is not None:
        final = v2ss
    elif trojan is None and v2ss is None:
        return None
    else:
        # not None in [trojan, v2ss]:
        final = copy.deepcopy(trojan)
        final["proxies"] += v2ss["proxies"]
        final["rules"] = sorted(
            list(set(trojan["rules"]).union(set(v2ss["rules"]))),
            key=lambda x: rule_key(x),
        )
    final["secret"] = "canyoukissme"
    final["proxy-groups"] = list()
    # read_ruleset_as_providers(final)
    read_ruleset_as_rules(final)
    final["rules"] = finalize_rules(final["rules"])
    finalize_groups(final)
    return final


if __name__ == "__main__":
    v2ss_link = os.getenv("V2SS_LINK", "").strip()
    trojan_link = os.getenv("TROJAN_LINK", "").strip()

    if not v2ss_link:
        print("WARNNING: empty V2SS_LINK env")

    if not trojan_link:
        print("WARNNING: empty TROJAN_LINK env")

    trojan = read_remote_config(trojan_link)
    v2ss = read_remote_config(v2ss_link)

    final = finalize(trojan, v2ss)
    if not final:
        raise RuntimeError(
            "At least one of V2SS_LINK and TROJAN_LINK env should be set"
        )
    ofile = "config.%s" % time.strftime("%Y%m%d")
    with open(ofile, "w") as ofile:
        dump(final, ofile)
