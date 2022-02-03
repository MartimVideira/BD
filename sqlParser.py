import sys
from tkinter.messagebox import RETRY
from bs4 import BeautifulSoup
import requests

sql_reserved_keywords = set()

sql_keywords_link = "https://www.drupal.org/docs/develop/coding-standards/list-of-sql-reserved-words"

requested = requests.get(sql_keywords_link)

soup = BeautifulSoup(requested.content,"html.parser")

keyword_list = soup.find("ol")
for listItem in keyword_list.childGenerator():
    sql_reserved_keywords.add(listItem.getText())



def strip_specials(word,closed_parentesis=False):
    specialCaracters = {'.',';','\t','\n','(',')'}

    if len(word)==0 or word[-1] not in specialCaracters and not closed_parentesis:
        return word
    if word[-1] == ')':
        return strip_specials(word[:-1],True)
    if word[-1] == '(' and closed_parentesis:
        return strip_specials(word[:-1],False)
    return strip_specials(word[:-1],closed_parentesis)

def choose_formating_func(stringarg :str):
   
    if stringarg[-1] == 'l':
        return lambda x : x.lower()
    elif stringarg[-1] == 'c':
        return lambda x : x.capitalize()
    else:
        return lambda x : x.upper()

args = sys.argv
file_indx = 2 if len(args) == 3 else 1
formating_func = choose_formating_func(args[1])
filename = args[file_indx]


with open(filename,"r") as f:
    file_content : list = f.readlines()


def comparable_word(word):
    if(len(word) == 0):
        return word
    upper_word = word.upper()
    return strip_specials(upper_word)

parsed_content = []
for  line in file_content:
    parsed_line = []
    for word in line.split(" "):
        comparable = comparable_word(word)
        if comparable in sql_reserved_keywords:
            parsed_line.append(formating_func(word))
        else:
            parsed_line.append(word)
    
    parsed_content.append(" ".join(parsed_line))


with open(filename,"w") as f:
    for line in parsed_content:
        f.writelines(line)
        
    

