import json
from pathlib import Path
from collections import Counter

path = Path("/Users/ext_riley/repos/nvim-config/based/notes/plugins.json")
d = json.loads(path.read_text())
sorter = {"selected": 0, "vendor": 1, "trying": 2, "next": 3, "prioritized": 4, "pending": 5, "later": 6, "rejected": 7}
d.sort(key=lambda x: (x["decision"], x["projects"]))
c = Counter((x["decision"] for x in d))
print(c)




# selected = set(
#     Path("/Users/ext_riley/repos/nvim-config/testing/selected.txt").read_text().split("\n")
# )
# # for x in d:
# #     if x["link"] in selected:
# #         x["decision"] = "trying"

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


path.write_text(json.dumps(d, indent=4, ensure_ascii=False))