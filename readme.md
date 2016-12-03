## Feiwen

A tool for modeliing documents containing emojis.

### TODO:

1. Get some data, the format should be 
```
{
	"id": STRING, 
	"text": "....",
	"sentiment": "POS" || "NEG",
	"emoji_class": "+" || "-"
}
```
2. Split the data by emoji class
3. Get emoji2vec vectors
4. Generate doc2vec based on (2) and (3)
5. Visualise the data in 2 by something like tsne