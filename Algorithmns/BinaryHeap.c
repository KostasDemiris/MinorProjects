#include <stdio.h>
#include <stdlib.h>
#include <time.h>  // this is for random, and only for testing purposes

typedef struct pair{
    int value;
    int priority;
} pair;

pair create_new_pair(int value, int priority){
    pair* new_value;
    new_value = (pair*) malloc(sizeof(pair));
    new_value->value = value;
    new_value->priority = priority;
    return *new_value;
}

int min(int one, int two){
    if (one < two){
        return one;
    }
    return two;
}

void heap_insert(pair* heap, int size, int value, int priority, int maximum_length){
    // all the other functions don't have a maximum length, and that's because this function (for the implmentation I went with)
    // the comparision to the last value's priority and subsequent replacement rather than going for the next value only occurs when 
    // the maximum length of the binary heap is exceeded, and this was the easiest way to interface it in my opinion
    int index;
    if (size != 0 && size >= maximum_length && heap[maximum_length].priority > priority) {return;}
    else{
        if (size >= maximum_length) {index = maximum_length;} // if the list is full, and it's got a higher priority than the least prioritised value,
        // replace that one.
        else {index = size + 1;}// the element after the current last
    }
    
    pair new_pair = create_new_pair(value, priority);
    heap[index] = new_pair;
    while ((int) index/2 > 0){
        if (heap[(int) index/2].priority > heap[index].priority) { return; } // heap order has been restored
        pair temp = heap[index];
        heap[index] = heap[(int) index / 2];
        heap[(int) index / 2] = new_pair; 
        index = (int) index / 2;
    }
    return;
}

void heap_sink(pair* heap, int size){
    pair last = heap[1];
    int index = 1; 
    while ((index * 2) < (size)){
        if (heap[index].priority > heap[index * 2].priority && heap[index].priority > heap[(index * 2) + 1].priority) {return;}
        if ((index * 2) + 1 >= size){ // If it only has a single left child
            if (heap[index].priority < heap[(index * 2) + 1].priority) {
                heap[index] = heap[(index * 2) + 1];
                heap[index] = last;
            }
            return;
        }

        if (heap[index * 2].priority > heap[(index * 2) + 1].priority){
            heap[index] = heap[index * 2];
            heap[index] = last;
            index *= 2;
        }
        
        else{
            heap[index] = heap[(index * 2) + 1];
            heap[index] = last;
            index *= 2;
            index ++;
        }
    }
    return;
}

int heap_max_deletion(pair* heap, int size){
    pair root = heap[1]; pair last = heap[size-1];
    heap[1] = heap[size-1]; // no need to delete it since it'll be overwritten by any later inserts
    heap_sink(heap, size-1);
    return root.value;
}

void print_heap(pair* heap, int size){
    for (int index = 1; index < size; index++){
        printf("for index %d, the value is %d with priority %d. \n", index, heap[index].value, heap[index].priority);
    }
}

int check_heap_property(pair* heap, int size){
    for (int index = 1; index < size; index++){
        if (index * 2 < size && heap[index*2].priority > heap[index].priority) {return 0;}
        if ((index * 2) + 1 < size && heap[(index*2)+1].priority > heap[index].priority) {return 0;}
    }
    return 1;
}

int check_pair_property(pair* heap, int size){ // checks if all pairs have the same value and priority, just a testing function
    for (int index = 1; index < size; index++){
        if (heap[index].priority != heap[index].value) {return 0;}
    }
    return 1;
}


int main(void){
    srand(time(NULL));
    int gen_num = 50;
    int size = 0; 
    int max_length = 20;
    pair heap[max_length];
    int input[gen_num];
    for (int index = 0; index < gen_num; index++){
        input[index] = rand() % (gen_num);
        printf("%d  ", input[index]);
    } printf("\n");

    for (int index = 0; index < gen_num; index++){
        heap_insert(&heap[0], size, input[index], input[index], max_length);
        size = min((size+1), max_length);
    }
    print_heap(heap, size);
    printf("%d is heap property checker\n", check_heap_property(heap, size));
    printf("%d is the heap pair equivalence property\n", check_pair_property(heap, size));

}
