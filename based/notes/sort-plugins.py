import json
from pathlib import Path
from collections import Counter

path = Path("/Users/ext_riley/repos/nvim-config/based/notes/plugins.json")
d = json.loads(path.read_text())
for x in d:
    x["projects"] = sorted(set(x["projects"]))
sorter = dict(zip((
    "glean",
    "vendored",
    "configured",
    "selected",
    "vendor",
    "trying",
    "next",
    "sooner",
    "pending",
    "laterA",
    "laterB",
    "laterC",
    "laterD",
    "later",
    "extra",
    "rejected",
    "hack",
), range(20)))
d.sort(key=lambda x: (sorter[x["decision"]], x["projects"]))
c = Counter((x["decision"] for x in d))
print(c)




selected = set(
    x.lower()
    for x in 
    Path("/Users/ext_riley/repos/nvim-config/testing/selected.txt").read_text().split("\n")
)
projects = []
for x in d:
    if (x["decision"] == "trying") and (x["link"].lower() not in selected):
        print(x["link"])
    if x["decision"] == "pending":
        projects.extend(set(x["projects"]))


for k, v in Counter(projects).most_common():
    print(f"{k:<20} {v:>4}")

# links = {x["link"] for x in d}
# for link in (selected - links):
#     if link.startswith("h"):
#         print(link)
#         d.append({
#             "link": link,
#             "decision": "trying",
#             "projects": []
#         })


c = Counter((x["decision"] for x in d))
print(c)

# links = {x["link"] for x in d}
# for link in (selected - links):
#     if link.startswith("h"):
#         print(link)


c = {k: v for k, v in Counter((x["link"] for x in d)).items() if v > 1}
print(c)


def reformat(s: str) -> str:
    return s.replace('[\n            "', '["').replace('"\n        ]', '"]').replace('",\n            "', '","')


path.write_text(reformat(json.dumps(d, indent=4, ensure_ascii=False)))