import argparse
import os
from dotenv import load_dotenv
load_dotenv()

from insight_stream.client import upload_doc, upload_dir

def main():
    parser = argparse.ArgumentParser(description='Загрузка документов')
    parser.add_argument('index_id', type=str, help='ID бота')
    parser.add_argument('path', type=str, help='Путь к файлу или папке с файлами')

    args = parser.parse_args()
    index_id = args.index_id
    path = args.path

    if os.path.isfile(path):
        upload_doc(index_id, path)
    elif os.path.isdir(path):
        upload_dir(index_id, path)
    else:
        print("Указан неверный путь к файлу или папке") 

if __name__ == '__main__':
    main()

#To run:
#python create_bot.py new_bot_id /path/to/my_document.pdf
