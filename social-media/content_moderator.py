#sample
posts = [
    {"user": "Raju", "text": "I hate this platform http://badlink.com"},
    {"user": "Dinesh", "text": "This is a good day"},
    {"user": "Harsh", "text": "Such a toxic environment visit http://example.com"},
    {"user": "Tej", "text": "No bad vibes here"},
    {"user": "Abhi", "text": "Check this out http://coolstuff.com"}
]

banned_words = ["bad", "toxic", "hate"]


total_posts = len(posts)
cleaned = 0
blocked = 0


user_flags = {
    "Raju": 2,
    "Dinesh": 0,
    "Harsh": 1,
    "Tej": 1,
    "Abhi": 0
}

links = []

print("CLEANED POSTS:\n")

for post in posts:
    original_text = post["text"]
    cleaned_text = original_text

    for word in banned_words:
        if word in cleaned_text.lower():
            cleaned_text = cleaned_text.replace(word, "***")
            cleaned += 1

    words = cleaned_text.split()
    for w in words:
        if w.startswith("http"):
            links.append(w)

    if "***" in cleaned_text:
        blocked += 1

    print(f"{post['user']}: {cleaned_text}")

with open("links_found.txt", "w") as file:
    for link in links:
        file.write(link + "\n")

print("\nMODERATION REPORT:")
print(f"Total Posts Screened: {total_posts}")
print(f"Cleaned: {cleaned}")
print(f"Blocked: {blocked}")

print("\nUSER FLAG SUMMARY:")
for user, count in user_flags.items():
    print(f"{user}: {count} reports")