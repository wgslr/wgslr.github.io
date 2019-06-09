---
---

{% for post in site.posts %}
  <h2> <a href="{{ post.url }}">{{ post.title }}</a></h2>
  <small>{{ post.date | date: "%Y-%m-%d" }}</small>
  {{ post.excerpt }}
{% endfor %}
