#include <stdio.h>
#include <stdlib.h>

typedef struct priorityNode priorityNode;
priorityNode* create_intial_node(int element, int priority);

struct priorityNode{
    priorityNode* previousNode;
    int contents;
    int priority;
    priorityNode* nextNode;
};

typedef struct PriorityQueue{
    priorityNode* firstNode;
    priorityNode* lastNode;
} PriorityQueue;

void insert_element(priorityNode* next_node, priorityNode* previous_node, int element, int priority){
    if (next_node != NULL){
        if (next_node->priority < priority){
            insert_element(next_node->nextNode, next_node, element, priority);
        }
        else{
            priorityNode* new_node;
            new_node = (priorityNode*) malloc(sizeof(priorityNode));
            new_node->nextNode = next_node;
            new_node->previousNode = previous_node;
            new_node->contents = element;
            new_node->priority = priority;
            if (previous_node != NULL){
                next_node->previousNode = new_node;
                previous_node->nextNode = previous_node;
            }
            else{
                next_node->previousNode = new_node;
            }
            return;
        }
    }
    else{
        priorityNode* new_node;
        new_node = (priorityNode*) malloc(sizeof(priorityNode));
        new_node->nextNode = NULL;
        new_node->contents = element;
        new_node->previousNode = previous_node;
        new_node->priority = priority;
        previous_node->nextNode = new_node;
        return;
    }
}


void add_element(PriorityQueue* queue, int element, int priority){
    if (queue->firstNode == NULL){
        queue->firstNode = create_intial_node(element, priority);
        queue->lastNode = queue->firstNode;
    }
    else{
        if (queue->firstNode->priority < priority){
            priorityNode* new_node;
            new_node = (priorityNode*) malloc(sizeof(priorityNode));
            new_node->nextNode = NULL;
            new_node->contents = element;
            new_node->priority = priority;
            new_node->previousNode = queue->firstNode;
            new_node->previousNode->nextNode = new_node;
            queue->firstNode = new_node;
        }
        else{
            if (queue->lastNode->priority > priority){
                priorityNode* new_node;
                new_node = (priorityNode*) malloc(sizeof(priorityNode));
                new_node->contents = element;
                new_node->priority = priority;
                new_node->nextNode = queue->lastNode;
                queue->lastNode->previousNode = new_node;
                queue->lastNode = new_node;
            }
            else{
                insert_element(queue->lastNode, queue->lastNode->previousNode, element, priority);
            }
        }
    }
}


void print_nodes(priorityNode* address){
    printf("%d is the element, and %d its priority...\n", address->contents, address->priority);
    if (address->nextNode != NULL){
        print_nodes(address->nextNode);
    }
    else{
        printf("That was the last element!\n");
    }
}

void print_priority_queue(PriorityQueue* queue){
    if (queue->lastNode != NULL){
        print_nodes(queue->lastNode);
    }
    else{
        printf("The queue has no elements\n");
    }
}

priorityNode* priority_dequeue(PriorityQueue* queue){
    if (queue->firstNode == NULL){
        return queue->firstNode;
    }
    priorityNode* reference = queue->firstNode;
    queue->firstNode = queue->firstNode->previousNode;
    if (queue->firstNode != NULL){
        queue->firstNode->nextNode = NULL;
    }
    else{
        queue->lastNode = NULL;  // If the first and last node are the same, and the first is dequeued, then the last node is also dequeued
    }
    return reference;  
}

priorityNode* create_intial_node(int element, int priority){
    priorityNode* new_node;
    new_node = (priorityNode*) malloc(sizeof(priorityNode));
    new_node->contents = element;
    new_node->priority = priority;
    new_node->previousNode = NULL;
    new_node->nextNode = NULL;
    return new_node;
}

PriorityQueue* create_priority_queue(int* elements, int* priorities, int num_elements){
    PriorityQueue* queue;
    queue = (PriorityQueue*) malloc(sizeof(PriorityQueue));
    // priorityNode* first_node = create_intial_node(elements[0], priorities[0]);
    // queue->firstNode = first_node;
    // queue->lastNode = first_node;
    for (int index = 0; index < num_elements; index++){
        // printf("%d is ele, %d is prior\n", elements[index], priorities[index]);
        add_element(queue, elements[index], priorities[index]);
    }
    return queue;
}

int main(void){
    int elements[9] = {1, 2, 3, 4, 5};
    int priorities[9] = {5, 4, 3, 8, 1};
    PriorityQueue* queue = create_priority_queue(elements, priorities, 5);  // This still has issues that need to be fixed
    print_priority_queue(queue);
    priorityNode* reference = priority_dequeue(queue);
    printf("%d is the ele, and %d priority\n", reference->contents, reference->priority);
    add_element(queue, 10, 11);
    print_priority_queue(queue);
    priority_dequeue(queue);
    print_priority_queue(queue);
    
}
