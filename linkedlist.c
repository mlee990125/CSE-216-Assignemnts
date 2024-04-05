//
// linkedlist.c
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node {
    char *name;
    int id;
    //link to the next and the previous node
    struct node *next;
    struct node *prev;
};

struct node *make_node(char *name, int id) {
    //TODO: allocate memory of sizeof(struct node) bytes for n
    struct node *n = malloc(sizeof(struct node));
    //TODO: allocate memory of strlen(name)+1 bytes for n->name 
    n->name = malloc(strlen(name) + 1);
    //strcpy to n->name from name
    strcpy(n->name, name);
    //initialize other fields
    n->id = id;
    n->next = n->prev = NULL;
    return n;
}

void destroy_node(struct node *n) {
    printf("destroying node: %d, %s\n", n->id, n->name);
    //TODO: deallocate n->name
    free(n->name);
    //TODO: deallocate n
    free(n);
}

void add_node_between(struct node *pred,
                      struct node *succ,
                      struct node *n) {
    //TODO: insert n in between pred and succ
    n->prev = pred;
    n->next = succ;
    pred->next = n;
    succ->prev = n;
}

void remove_node(struct node *n) {
    //TODO: remove n from the linked list
    n->prev->next = n->next;
    n->next->prev -> n->prev;
}

struct node *get_list() {
    char name[256];
    int id;
    //make a head node (sentinel)
    struct node *head = make_node("head", -1);
    //circularly doubly linked list
    head->next = head->prev = head;

    while(1) {
        struct node *n;
        printf("enter name or quit to stop: ");
        scanf("%s", name);
        if(strcmp(name, "quit") == 0)
            break;
        printf("enter id: ");
        scanf("%d", &id);
        //TODO: make a node with name and id
        make_node(name, id);
        //TODO: add n to the last position of the list
        add_node_between(head->prev, head, n);
    }
    return head;
}

void print_list(struct node *head) {
    struct node *n;
    //TODO: from head->next until n reaches head, print n->id and n->name
    for(n = head->next ; n != head ; n = n ->next) {
        printf("%3d: %s\n", n->id, n->name);
    }
}

void destroy_list(struct node *head) {
    while(head->next != head) {
        struct node *n = head->next;
        //TODO: remove n from the list
        //TODO: destroy n
    }
    //TODO: destroy head
}

int main() {
    struct node *head;
    head = get_list();
    print_list(head);
    destroy_list(head);
}