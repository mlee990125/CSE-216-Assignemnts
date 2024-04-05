#include <stdio.h>
#include <stdlib.h>

typedef struct record {
    int id;
    int age;             
    char year[10];
    char name[50];
    char school[50];
    char EndOfRecord;
} record_t;

record_t data[25] = {
    {2,   23,   "junior",       "Abenner Abbe",         "SUNY Korea", ';'},
    {25,  20,   "freshman",     "Zinaida Bolormaa",     "SUNY Korea", ';'},
    {9,   22,   "sophomore",    "Elton Laurena",        "SUNY Korea", ';'},
    {11,  24,   "senior",       "Davida Marni",         "SUNY Korea", ';'},
    {17,  21,   "sophomore",    "Brigham Nellie",       "SUNY Korea", ';'},
    {18,  27,   "junior",       "Mica Brooklynn",       "SUNY Korea", ';'},
    {10,  21,   "junior",       "Lester Abraham",       "SUNY Korea", ';'},
    {13,  24,   "sophomore",    "Valary Shaquille",     "SUNY Korea", ';'},
    {14,  25,   "junior",       "Marion Julyan",        "SUNY Korea", ';'},
    {12,  26,   "freshman",     "Muriel Phemie",        "SUNY Korea", ';'},
    {3,   21,   "senior",       "Kidist Robert",        "SUNY Korea", ';'},
    {21,  20,   "sophomore",    "Layne Silvester",      "SUNY Korea", ';'},
    {19,  23,   "senior",       "Raynard Sampson",      "SUNY Korea", ';'},
    {6,   27,   "junior",       "Misi Hippolytos",      "SUNY Korea", ';'},
    {24,  20,   "freshman",     "Ogden Janie",          "SUNY Korea", ';'},
    {8,   19,   "freshman",     "Ural Gayatri",         "SUNY Korea", ';'},
    {20,  19,   "freshman",     "Roseanne Lucky",       "SUNY Korea", ';'},
    {22,  21,   "junior",       "Jordana Meagan",       "SUNY Korea", ';'},
    {4,   25,   "freshman",     "Andile Aureliana",     "SUNY Korea", ';'},
    {15,  23,   "senior",       "Deanna Delora",        "SUNY Korea", ';'},
    {1,   21,   "sophomore",    "Yeong Katyusha",       "SUNY Korea", ';'},
    {23,  23,   "senior",       "Joon Kailee",          "SUNY Korea", ';'},
    {5,   26,   "sophomore",    "Gioacchino Hadewych",  "SUNY Korea", ';'},
    {7,   18,   "senior",       "Andriy Dora",          "SUNY Korea", ';'},
    {16,  22,   "freshman",     "Peers Muriel",         "SUNY Korea", ';'},
};

extern size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
extern int fseek(FILE *stream, long offset, int whence); //whence can be SEEK_SET, SEEK_CUR, or SEEK_END

void print_record(record_t *rec) {
    printf("id: %-2d, age: %-2d, year: %-10s, name: %-20s, school: %s\n",
        rec->id, rec->age, rec->year, rec->name, rec->school);
}

//TODO: read rec from the file
int read_record(FILE *fp, record_t *rec) {
  return fread(rec, sizeof(record_t), 1, fp);
}

//TODO: write rec to the file
int write_record(FILE *fp, record_t *rec) {
  return fwrite(rec, sizeof(record_t), 1, fp);
}

//TODO: write rec to the file at the index
int write_record_at(FILE *fp, int index, record_t *rec) {
  fseek(fp, index * sizeof(record_t), SEEK_SET);
  return fwrite(rec, sizeof(record_t), 1, fp);
}

//TODO: sort records using the bucket sort
void sort_file(char *src_fname, char *dst_fname) {
  
}

//create a file and write data to it
void create_file(char *fname) {
    FILE *fp = fopen(fname, "wb");      //"w" for linux and mac
    for(int i = 0; i < 25; i++)
        write_record(fp, &data[i]);
    fclose(fp);
}

//print the records to the file
void print_file(char *fname) {
    record_t rec;
    FILE *fp = fopen(fname, "rb");      //"r" for linux and mac
    printf("--%s----------------\n", fname);
    while(read_record(fp, &rec) > 0)
        print_record(&rec);
    fclose(fp);
}

int main() {
    create_file("original.txt");
    print_file("original.txt");

    sort_file("original.txt", "sorted.txt");
    print_file("sorted.txt");
    
    return 0;
}