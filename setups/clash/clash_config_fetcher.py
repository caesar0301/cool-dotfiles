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


def read_rule_providers():
    filename = "rule_providers.yaml"
    with open(filename) as ifile:
        try:
            return safe_load(ifile)
        except yaml.YAMLError as ex:
            print(ex)
            return dict()


def finalize_rules(rules):
    gfwr = gfwrules()
    allrules = set(rules + gfwr)
    res = sorted([i for i in set(allrules) if not i.startswith("MATCH,")])
    res.append("MATCH,DIRECT")
    return res


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
    providers = read_rule_providers()
    final["rule-providers"] = providers.get("rule-providers", [])
    final["proxy-groups"] = list()
    final["rules"] = finalize_rules(final["rules"])

    selected_proxies = []
    selected_countries = ["美国", "日本", "香港", "澳大利亚"]
    for cname in selected_countries:
        selected_proxies += [i for i in final["proxies"] if cname in i["name"]]
    final["proxies"] = selected_proxies

    # unified group, required by client
    auto_group = create_proxy_group(
        name="Auto", proxy_configs=final["proxies"], type="url-test"
    )
    add_group(final, auto_group)

    # selected country groups
    country_groups = {"美国": "AutoUS", "日本": "AutoJP"}
    for cname in country_groups:
        cproxies = [i for i in final["proxies"] if cname in i["name"]]
        cgroup = create_proxy_group(
            name=country_groups[cname], proxy_configs=cproxies, type="url-test"
        )
        add_group(final, cgroup)

    manual_group = create_proxy_group(
        name="Proxy",
        proxy_configs=final["proxies"],
        type="select",
        extra_names=["Auto"] + list(country_groups.values()),
    )
    add_group(final, manual_group)

    return final


if __name__ == "__main__":
    v2ss_link = os.getenv("V2SS_LINK", "").strip()
    trojan_link = os.getenv("TROJAN_LINK", "").strip()

    if not v2ss_link:
        print("WARNNING: emptry V2SS_LINK env")

    if not trojan_link:
        print("WARNNING: emptry TROJAN_LINK env")

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
