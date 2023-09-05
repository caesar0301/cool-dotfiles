#!/usr/bin/env python3
from yaml import load, dump
from yaml import Loader, Dumper
import copy
import urllib.request
import os


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


if __name__ == "__main__":
    v2ss_link = os.getenv("V2SS_LINK")
    trojan_link = os.getenv("TROJAN_LINK")

    trojan = read_remote_config(trojan_link)
    v2ss = read_remote_config(v2ss_link)

    if trojan is not None and v2ss is None:
        final = trojan
    elif trojan is None and v2ss is not None:
        final = v2ss
    elif not None in [trojan, v2ss]:
        # Fianlize merging
        final = copy.deepcopy(trojan)
        final["secret"] = "canyoukissme"
        final["proxies"] += v2ss["proxies"]
        final["proxy-groups"] = [
            create_proxy_group(
                name="AutoTrojan", proxy_configs=trojan["proxies"], type="url-test"
            ),
            create_proxy_group(
                name="AutoV2ss", proxy_configs=v2ss["proxies"], type="url-test"
            ),
            create_proxy_group(
                name="Proxy",
                proxy_configs=trojan["proxies"] + v2ss["proxies"],
                type="select",
                extra_names=["AutoTrojan", "AutoV2ss"],
            ),
        ]
        final["rules"] = sorted(
            list(set(trojan["rules"]).union(set(v2ss["rules"]))),
            key=lambda x: rule_key(x),
        )
    else:
        final = None
        raise RuntimeError(
            "At least one of V2SS_LINK and TROJAN_LINK env should be set"
        )

    if final:
        print(dump(final, Dumper=Dumper))
