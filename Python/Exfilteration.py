import nltk
nltk.download('stopwords')
nltk.download('punkt')
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize


txt = "a long string of text about him and her\nds\txbxcb"
stop_words = set(stopwords.words('english'))
word_tokens = word_tokenize(txt)
filtered_sentence = []
for w in word_tokens:
    if w not in stop_words:
        filtered_sentence.append(w)

print(filtered_sentence)