#include <stdio.h>
#include <stdlib.h>
#include <time.h>  // this is for random, and only for testing purposes

typedef struct pair{
    int value;
    int priority;
} pair;

typedef struct binaryHeap{
    int max_length; 
    // constraint, must be greater than or equal to 2, one for empty and one for first value. An empty heap is invalid in my definition
    int current_length;
    pair** pairs;
} binaryHeap;

int min(int one, int two){
    if (one < two) {return one;}
    return two;
}

pair* create_new_pair(int value, int priority){
    pair* new_value;
    new_value = (pair*) malloc(sizeof(pair));
    new_value->value = value;
    new_value->priority = priority;
    return new_value;
}

void heap_swim(binaryHeap* heap){
    int index = heap->current_length;
    while ((int) index/2 >= 1){
        if (heap->pairs[index]->priority <= heap->pairs[(int) index/2]->priority) {return;}
        pair* temp = heap->pairs[index];
        heap->pairs[index] = heap->pairs[(int) index/2];
        heap->pairs[(int) index/2] = temp;
       index = (int) index/2;
    }
}

void heap_insert(binaryHeap* heap, int value, int priority){
    if (heap->current_length == 0) {
        heap->pairs[1] = create_new_pair(value, priority);
        heap->current_length++;
        return;
        }
    if (heap->current_length == heap->max_length) {
        // If the heap is full, only insert the value if it has more priority than the least prioritised current element;
        if (heap->pairs[heap->max_length]->priority < priority){
            free(heap->pairs[heap->max_length]);
            heap->pairs[heap->max_length] = create_new_pair(value, priority);
            heap_swim(heap);
        }
        return;
        
    }
    heap->pairs[heap->current_length+1] = create_new_pair(value, priority);
    heap->current_length++;
    heap_swim(heap);
}

void heap_sink(binaryHeap* heap){
    int index = 1;

    while (index < heap->current_length){
        int add = 0;
        if (index*2 <= heap->current_length){
            if (heap->pairs[index*2]->priority > heap->pairs[index]->priority){
                add = index*2;
            }
        }
        if ((index*2)+1 <= heap->current_length){
            if (heap->pairs[(index*2)+1]->priority > heap->pairs[index]->priority && heap->pairs[(index*2)+1]->priority > heap->pairs[index*2]->priority)
            {
                add = (index*2)+1;
            }
        }
        if (add == 0) {return;}
        pair* temp = heap->pairs[index];
        heap->pairs[index] = heap->pairs[add];
        heap->pairs[add] = temp;
        index = add;
    }

    // while (index < heap->current_length){
    //     if ((index*2)+1 < heap->current_length){
    //         if (heap->pairs[(index*2)+1]->priority < heap->pairs[index]->priority && heap->pairs[index*2]->priority < heap->pairs[index]->priority){
    //             // this means the heap order has been restored
    //             return;
    //         }
    //         if (heap->pairs[(index*2)+1]->priority > heap->pairs[index*2]->priority){
    //             pair* temp = heap->pairs[index];
    //             heap->pairs[index] = heap->pairs[(index*2)+1];
    //             heap->pairs[(index*2)+1] = temp;
    //             index = (index*2) + 1;
    //         }
    //         else{
    //             if (heap->pairs[(index*2)+1]->priority < heap->pairs[index*2]->priority){
    //                 pair* temp = heap->pairs[index];
    //                 heap->pairs[index] = heap->pairs[index*2];
    //                 heap->pairs[index*2] = temp;
    //                 index *= 2;
    //             }
    //             else{
    //                 return;
    //             }
    //         }
            
    //     }
    //     else{
    //         if (index*2 < heap->current_length){
    //             if (heap->pairs[index*2]->priority < heap->pairs[index]->priority){
    //                 // again, restored heap order.
    //                 return;
    //             }
    //             pair* temp = heap->pairs[index];
    //             heap->pairs[index] = heap->pairs[index*2];
    //             heap->pairs[index*2] = temp;
    //             index *= 2;
    //         }
    //         else{
    //             // it's a leaf node so to speak, so naturally order has been restored.
    //             return;
    //         }
    //     }
        
    // }
}

int heap_max_delete(binaryHeap* heap){
    if (heap->current_length < 1) {return NULL;} 
    int returnable = heap->pairs[1]->value;
    pair* freeable = heap->pairs[1];
    heap->pairs[1] = heap->pairs[heap->current_length];
    free(freeable);
    heap->current_length--;
    heap_sink(heap);
    return returnable;

}

binaryHeap* create_binary_heap(int maximum_length){
    binaryHeap* heap;
    heap = (binaryHeap*) malloc(sizeof(binaryHeap));
    heap->current_length = 0;
    heap->max_length = maximum_length;
    heap->pairs = (pair**) malloc(sizeof(pair*) * maximum_length);
    return heap;
}

void print_binary_heap(binaryHeap* heap){
    for (int index = 1; index < heap->current_length+1; index++){
        printf("index %d has value %d and priority %d\n", index, heap->pairs[index]->value, heap->pairs[index]->priority);
    }
}

int check_heap_order_property(binaryHeap* heap){
    // Checks that a heap fulfills the required heap order property
    for (int index = 1; index < heap->current_length; index++){
        if (index * 2 < heap->current_length && heap->pairs[index*2]->priority > heap->pairs[index]->priority) {return 0;}
        if ((index * 2) + 1 < heap->current_length && heap->pairs[(index*2)+1]->priority > heap->pairs[index]->priority) {return 0;}
    }
    return 1;
}

int check_heap_symmetry_property(binaryHeap* heap){
    // Checks that a heap fulfills the required heap symmetry property
    for (int index = 1; index < heap->current_length; index++) {if (heap->pairs[index]->priority != heap->pairs[index]->value) {return 0;}}
    return 1;
}

int main(void){
    srand(time(NULL));

    int gen_num = 50;
    int max_length = 20;


    int input[gen_num];
    for (int index = 0; index < gen_num; index++){
        input[index] = rand() % (gen_num);
        printf("%d  ", input[index]);
    } printf("\n");

    binaryHeap* heap = create_binary_heap(max_length);
    for (int index = 0; index < gen_num; index++){
        heap_insert(heap, input[index], input[index]);
    }



    print_binary_heap(heap);
    printf("order property is %d\n", check_heap_order_property(heap));
    printf("symmetry property is %d\n", check_heap_symmetry_property(heap));
    printf("the dequeued value is %d and the length is now %d\n", heap_max_delete(heap), heap->current_length);
    printf("%d is heap prop now\n", check_heap_order_property(heap));
    

    while (heap->current_length > 2){
        printf("%d %d \n", heap_max_delete(heap), check_heap_order_property(heap));
        // print_binary_heap(heap);
        // printf("\n\n\n");
    }
// }
