import os
import sys
import openai
import dotenv
from dotenv import load_dotenv

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")
def get_response(prompt):

    prompt = "Please reformat this python function with comments and suggest if there are any bugs:\n" + prompt
    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=prompt,
        temperature=0.6,
    )
    
    length = len(os.listdir("./logs/"))
    with open("./logs/log_"+str(length)+".txt", "w+") as fw:
        fw.write(str(response) + "\n\n\n")
    result = response["choices"][0]["text"]
    return result


if __name__ == "__main__":
    response = get_response(sys.argv[1])
    print(response)

