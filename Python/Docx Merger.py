from docxcompose.composer import Composer
from docx import Document as Document_compose


def combine_all_docx(docx_list):
    filename_master = docx_list[0]
    docx_list = docx_list[1:]
    number_of_sections = len(docx_list)
    master = Document_compose(filename_master)
    composer = Composer(master)
    for i in range(0, number_of_sections):
        doc_temp = Document_compose(docx_list[i])
        composer.append(doc_temp)
    composer.save("combined_file.docx")


files_list = list()
while True:
    filename = input(f"Enter file number {len(files_list) + 1} (Enter to end): ")
    if filename == "":
        break
    elif filename[-5:] != ".docx":
        print("Please enter a file with '.docx' extension.")
        continue
    else:
        files_list.append(filename)
# files_list = ["file1.docx", "file2.docx", "file3.docx", "file4.docx"]
try:
    combine_all_docx(files_list)
    print("Success!")
except:
    print("Failed!")
