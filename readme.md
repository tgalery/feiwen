## Feiwen

A tool for modeliing documents containing emojis.

### Setup

This project partially depends on python, R and [emoji2vec](https://github.com/uclmr/emoji2vec), which has been added as a git submodule in this project. In order to install all dependencies, you need to:

1. Have [mini conda](http://conda.pydata.org/miniconda.html) installed and executable your command line prompt.
2. Create the `feiwen` python virtual environment: `conda env create -f environment.yml`
3. git submodule update --init --recursive (This pulls emoji2vec into libs/emoji2vec)

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


### References:

- [Paragraph2Vec](https://arxiv.org/pdf/1405.4053v2.pdf)
