{- DO NOT CHANGE MODULE NAME, if you do, the file will not load properly -}
   module Coursework where

   import Data.List
   import qualified Data.Set as HS (fromList, toList)
   import Test.QuickCheck
   
   {-
     Your task is to design a datatype that represents the mathematical concept of
     a (finite) set of elements (of the same type). We have provided you with an
     interface (do not change this!) but you will need to design the datatype and
     also support the required functions over sets. Any functions you write should
     maintain the following invariant: no duplication of set elements.
   
     There are lots of different ways to implement a set. The easiest is to use a
     list. Alternatively, one could use an algebraic data type, wrap a binary
     search tree, or even use a self-balancing binary search tree. Extra marks will
     be awarded for efficient implementations (a self-balancing tree will be more
     efficient than a linked list for example).
   
     You are **NOT** allowed to import anything from the standard library or other
     libraries. Your edit of this file should be completely self-contained.
   
     **DO NOT** change the type signatures of the functions below: if you do, we
     will not be able to test them and you will get 0% for that part. While sets
     are unordered collections, we have included the Ord constraint on some
     signatures: this is to make testing easier.
   
     You may write as many auxiliary functions as you need. Everything must be in
     this file.
   
     See the note **ON MARKING** at the end of the file.
   -}
   
   {-
      PART 1.
      You need to define a Set datatype.
   -}
   
   -- you **MUST** change this to your own data type. The declaration of Set a =
   -- Int is just to allow you to load the file into ghci without an error, it
   -- cannot be used to represent a set.
   data Set a = Empty | Node Int a (Set a) (Set a) deriving (Show) -- The int is the balancing factor

   -- The following are aux functions for set operations

   countNodes :: Set a -> Int -> Int
   countNodes Empty acc = acc
   countNodes (Node bf x subtree_1 subtree_2) acc = countNodes subtree_2 (countNodes subtree_1 (acc + 1)) 

   isIn :: (Eq a) => a -> [a] -> Bool
   isIn target [] = False
   isIn target (x: xs)
      | (target == x) = True
      | otherwise = isIn target xs

   removeFrom :: (Eq a) => a -> [a] -> [a]
   removeFrom val [] = []
   removeFrom val (x: xs)
      | (val == x) = xs
      | otherwise = x : (removeFrom val xs)

   unique :: (Eq a) => [a] -> [a] -> [a]
   unique [] acc = acc
   unique (x: xs) acc
      | (isIn x acc) = unique xs acc
      | otherwise = [x] ++ (unique xs acc)

   myMax :: (Ord a) => [a] -> a  -- Takes in two a values and compares them to see which one is greater
   myMax (x: y: xs)
      | (x > y) = x
      | otherwise = y

   lazyLength :: [a] -> Int -> Bool -- Length checks all n elements so this only checks whether length is less than or equal to the given value (more efficient)
   lazyLength [] len = True
   lazyLength (x: xs) 0 = False
   lazyLength (x: xs) len = lazyLength xs (len - 1)

   quicksort :: (Ord a) => [a] -> [a] -- This is actually a set implementation of this in which we don't consider vals equal to x cause we don't have to, they're all unique
   quicksort [] = []
   quicksort (x: xs) = (quicksort $ filter (<x) xs) ++ [x] ++ (quicksort $ filter (>x) xs)

   getLeft :: Set a -> Set a
   getLeft (Node bf x subtree_1 subtree_2) = subtree_1
   getLeft (Empty) = Empty

   getRight :: Set a -> Set a
   getRight (Node bf x subtree_1 subtree_2) = subtree_2
   getRight (Empty) = Empty

   getValue :: Set a -> a -- Cannot take in an empty val or will crash
   getValue (Node bf x subtree_1 subtree_2) = x

   getBalanceFactor :: Set a -> Int
   getBalanceFactor (Empty) = 0
   getBalanceFactor (Node bf x subtree_1 subtree_2 ) = bf

   updateBalanceFactor :: Set a -> Int -> Set a
   updateBalanceFactor (Empty) new = (Empty)
   updateBalanceFactor (Node _ x subtree_1 subtree_2) new = (Node new x subtree_1 subtree_2)

   updateAllBalanceFactor :: Set a -> Set a
   updateAllBalanceFactor (Empty) = (Empty)
   updateAllBalanceFactor (Node bf x subtree_1 subtree_2) = (Node (calculateBalanceFactor (Node bf x subtree_1 subtree_2)) x (updateAllBalanceFactor subtree_1) (updateAllBalanceFactor subtree_2))

   isLeaf :: Set a -> Bool
   isLeaf (Node bf x subtree_1 subtree_2)
      | ((Coursework.null subtree_1) && (Coursework.null subtree_2)) = True
      | otherwise = False
   isLeaf Empty = False -- it's technically not though

   createList :: (Ord a) => [a] -> Set a -> Set a  -- n log n implementation, more efficient at eliminating non-unique values.
   createList [] set = set
   createList (x: xs) set = createList xs (Coursework.insert x set)

   height :: Set a -> Int -> Int
   height Empty acc = acc
   height (Node bf x subtree_1 subtree_2) acc
      | (bf <= (-1)) = height subtree_1 (acc + 1)
      | otherwise = height subtree_2 (acc + 1) -- if its 0 then it doesn't matter which side we choose

   calculateBalanceFactor :: Set a -> Int
   calculateBalanceFactor (Empty) = 0
   calculateBalanceFactor (Node bf x subtree_1 subtree_2) = ((height subtree_1 0) - (height subtree_2 0))

   isBalanced :: Set a -> Bool
   isBalanced Empty = True
   isBalanced (Node bf x subtree_1 subtree_2)
      | (bf == 0) = True
      | (bf == 1) = isBalanced subtree_2
      | (bf == (-1)) = isBalanced subtree_1
      | otherwise = False

   -- temp breaking previous naming conventions of subtree_1 and subtree_2 because it was getting very long and thus unreadable in the balance functions

   bfLR_l :: Set a -> Int  -- This finds the bf of the LEFT node, for the LR case
   bfLR_l (Node bf x left right)
      | (bf == (-1)) = 0
      | otherwise = (-1)
   bfLR_l (Empty) = (-1)

   bfLR_r :: Set a -> Int  -- This finds the bf of the RIGHT node, for the LR case
   bfLR_r (Node bf x left right)
      | (bf == 1) = 0
      | otherwise = 1
   bfLR_r (Empty) = 1

   bfRL_l :: Set a -> Int  -- This finds the bf of the LEFT node, for the RL case
   bfRL_l (Node bf x left right)
      | (bf == (-1)) = 0
      | otherwise = (-1)
   bfRL_l (Empty) = 1

   bfRL_r :: Set a -> Int  -- This finds the bf of the RIGHT node, for the RL case
   bfRL_r (Node bf x left right)
      | (bf == 1) = 0
      | otherwise = 1
   bfRL_r (Empty) = 1

   simpleBalance :: (Ord a) => a -> Set a -> Set a -> Set a
   simpleBalance x (Node bf val left right) (Empty) -- Left leaning simple node structure
      | (bf == (-1)) = Node 0 val (left) (Coursework.singleton x)
      | (bf == (1)) = Node 0 (getValue right) (Coursework.singleton val) (Coursework.singleton x)
      | otherwise = (Coursework.insert x (Node bf val left right)) -- This should never be the case, but if somehow it does, this will not crash hopefully
   simpleBalance x (Empty) (Node bf val left right) -- Right leaning simple node strcuture
      | (bf == (-1)) = Node 0 (getValue left) (Coursework.singleton x) (Coursework.singleton val)
      | (bf == (1)) = Node 0 (val) (Coursework.singleton x) (Coursework.singleton (getValue right))
   simpleBalance x left right = Node ((height right 0) - (height left 0)) x right left -- just in case


   -- This continues down until it reaches an unbalanced node with balanced subtrees. 
   -- From here (because balanced subtrees), we can abstract away the layers past the top two layers of subtrees.
   balanceSet :: (Ord a) => Set a -> Set a
   balanceSet (Empty) = Empty
   balanceSet (Node bf x left right) 
      | (isBalanced left == False) = balanceSet left
      | (isBalanced right == False) = balanceSet right
      | (bf == (-2)) 
         = if (countNodes (Node bf x left right) 0) == 3 -- this is inside the loop to prevent counting all nodes of a balanced big tree unnecessarily
            then
               simpleBalance x left right -- There is a simple node struct to balance
            else 
               if (getBalanceFactor left == (-1)) -- LL Node is the problem, Tree 3 exists
                  then
                     (Node 0 (getValue left) (getLeft left) (Node 0 x (getRight left) (right)))
                  else  -- LR Node is the problem, Tree 3 exists
                     Node 0 (getValue (getRight left)) (Node (bfLR_l (getRight left)) (getValue left) (getLeft left) (getLeft (getRight left)))
                     (Node (bfLR_r (getRight left)) x (getRight (getRight left)) right)
      | (bf == (2))
         = if (countNodes (Node bf x left right) 0) == 3
            then 
               simpleBalance x left right
            else
               if (getBalanceFactor right  == (-1)) -- RL Node is the problem, tree 3 exists
                  then
                     Node 0 (getValue (getLeft right)) (Node (bfRL_l (getLeft right)) x left (getLeft (getLeft right)))
                     (Node (bfRL_r (getLeft right)) (getValue right) (getRight (getLeft right)) (getRight right))
                  else  -- RR Node is the problem, tree 3 exists
                     (Node 0 (getValue right) (Node 0 x (left) (getLeft right)) (getRight right))
      | otherwise = (Node bf x left right)

   createNode :: a -> Set a -> Set a -> Set a
   createNode x tree_1 tree_2 = (Node ((height tree_2 0) - (height tree_1 0)) x tree_1 tree_2)

   setOfSets :: [[a]] -> Set (Set a) -- takes in a list of lists and returns a set of sets
   setOfSets listOfLists = fromListNoOrd [fromListNoOrd list | list <- listOfLists]

   splitListThree :: [a] -> Int -> [[a]] 
   -- List, pivot, and a list of lists (will have three elements), must be at least three elements cause i removed checks to maximise efficiency (checks below in case this doesn't work)
   -- splitListThree [] piv = [[], [], []]
   -- splitListThree (x: xs) 0 = [] : [x] : [xs]
   splitListThree list piv = [(take (piv) list), [list !! piv], (drop (piv+1) list)]

   selectBin :: [a] -> [Bool] -> [a] -- takes in a same length list of values and list of bools, and returns all of the values for which the equivalent bool is true
   selectBin [] bools = []
   selectBin list [] = []
   selectBin (x: xs) (y: ys)
      | y = x: selectBin xs ys
      | otherwise = selectBin xs ys

   toBinary :: Int -> [Bool] -- More accurately, to a list of bools
   toBinary 0 = [False]
   toBinary value
      | (value `mod` 2 == 0) = [False] ++ toBinary (value `div` 2)
      | otherwise = [True] ++ toBinary (value `div` 2)

   combin :: [a] -> [[a]]
   combin list = [selectBin (list) (toBinary binar) | binar <- [0 .. (2 ^ (length list))-1]]

   altCombs :: [a] -> [[a]]
   altCombs [] = [[]]
   altCombs (x: xs) = (map (x:) (altCombs xs)) ++ (altCombs xs)

   {-
      PART 2.
      If you do nothing else, you must get the toList, fromList and equality working. If they
      do not work properly, it is impossible to test your other functions, and you
      will fail the coursework!
   -}
   
   -- toList {2,1,4,3} => [1,2,3,4]
   -- the output must be sorted.
   toList :: Ord a => Set a -> [a]
   toList (Empty) = []
   toList (Node bf x subtree_1 subtree_2) = (toList subtree_1) ++ [x] ++ (toList subtree_2)

   toListNoOrd :: Set a -> [a] -- Already sorted, so we can do this to remove the need for an Ord
   toListNoOrd Empty = []
   toListNoOrd (Node bf x subtree_1 subtree_2) = (toListNoOrd subtree_1) ++ [x] ++ (toListNoOrd subtree_2)
   
   -- fromList: do not forget to remove duplicates!
   fromList :: Ord a => [a] -> Set a
   fromList xs = createList (xs) (Empty) -- This is cooler but less efficient...

   fromListNodifierNoOrd :: [[a]] -> Set a -- Method of efficiently processing the split list output, this feeds back to fromListFormat
   fromListNodifierNoOrd (x: y: z: rest) = createNode (y !! 0) (fromListFormatNoOrd x) (fromListFormatNoOrd z)
 
   fromListFormatNoOrd :: [a] -> Set a -- From list, except now it doesn't require Ord, since it uses lazyLength instea
   fromListFormatNoOrd [] = Empty
   fromListFormatNoOrd list
      | (lazyLength list 1) = (Node 0 (list !! 0) (Empty) (Empty))
      | (lazyLength list 2) = (Node 1 (list !! 0) (Empty) (Coursework.singleton (list !! 1)))  -- Already ordered, y must be > x
      | otherwise = fromListNodifierNoOrd (splitListThree list (length list `div` 2))

   fromListNoOrd :: [a] -> Set a
   fromListNoOrd list = fromListFormatNoOrd list -- This doesn't check for repeats or orders, because a) those are already done and b) there's no ord or eq here

   
   -- Make sure you satisfy this property. If it fails, then all of the functions
   -- on Part 3 will also fail their tests
   toFromListProp :: IO ()
   toFromListProp =
     quickCheck
       ((\xs -> (HS.toList . HS.fromList $ xs) == (toList . fromList $ xs)) :: [Int] -> Bool)
   
   -- test if two sets have the same elements (pointwise equivalent).
   instance (Ord a) => Eq (Set a) where
     s1 == s2 = ((toList s1) == (toList s2))
   
   -- you should be able to satisfy this property quite easily
   eqProp :: IO ()
   eqProp =
     quickCheck ((\xs -> (fromList . toList . fromList $ xs) == fromList xs) :: [Char] -> Bool)
   
   {-
      PART 3. Your Set should contain the following functions. DO NOT CHANGE THE
      TYPE SIGNATURES.
   -}
   
   -- the empty set
   empty :: Set a
   empty = Empty
   
   -- is it the empty set?
   null :: Set a -> Bool
   null Empty = True
   null (Node bf x subtree_1 subtree_2) = False
   
   -- build a one element Set
   singleton :: a -> Set a
   singleton x = (Node 0 x (Empty) (Empty))
   
   -- insert an element *x* of type *a* into Set *s* make sure there are no
   -- duplicates!
   insert :: (Ord a) => a -> Set a -> Set a
   insert val (Empty) = (Node 0 val (Empty) (Empty))
   insert val (Node bf x subtree_1 subtree_2)
      | (val < x) = balanceSet (createNode x (Coursework.insert val subtree_1) (subtree_2)) -- So that we can recalculate bf if it changes
      | (val > x) = balanceSet (createNode x (subtree_1) (Coursework.insert val subtree_2))
      | otherwise = (Node bf x subtree_1 subtree_2)
   
   -- join two Sets together be careful not to introduce duplicates.
   union :: (Ord a) => Set a -> Set a -> Set a
   union (Empty) tree_2 = tree_2
   union (Node bf x subtree_1 subtree_2) tree_2 = Coursework.union (subtree_2) (Coursework.union subtree_1 (Coursework.insert x tree_2))
   
   myIntersection :: (Ord a) => Set a -> Set a -> Set a -> Set a
   myIntersection (Empty) tree_2 acc_tree = acc_tree
   myIntersection (Node bf x subtree_1 subtree_2) tree_2 acc_tree
      | (member x tree_2) = myIntersection (subtree_1) (tree_2) (myIntersection (subtree_2) (tree_2) (Coursework.insert x acc_tree))
      | otherwise = myIntersection (subtree_1) (tree_2) (myIntersection (subtree_2) (tree_2) (acc_tree))

   -- return, as a Set, the common elements between two Sets
   intersection :: (Ord a) => Set a -> Set a -> Set a
   intersection (Empty) tree_2 = tree_2
   intersection tree_1 tree_2 = myIntersection tree_1 tree_2 (Empty)
   
   myDifference :: (Ord a) => Set a -> Set a -> Set a -> Set a
   myDifference (Empty) tree_2 acc_tree = acc_tree
   myDifference (Node bf x subtree_1 subtree_2) tree_2 acc_tree
      | ((member x tree_2) == False) = myDifference subtree_2 tree_2 (myDifference subtree_1 tree_2 (Coursework.insert x acc_tree))
      | otherwise = myDifference subtree_2 tree_2 (myDifference subtree_1 tree_2 (acc_tree))

   -- all the elements in *s1* not in *s2*
   -- {1,2,3,4} `difference` {3,4} => {1,2}
   -- {} `difference` {0} => {}
   difference :: (Ord a) => Set a -> Set a -> Set a
   difference (Empty) tree_2 = tree_2
   difference tree_1 tree_2 = myDifference tree_1 tree_2 (Empty)
   
   -- is element *x* in the Set s1?
   member :: (Ord a) => a -> Set a -> Bool
   member val (Empty) = False
   member val (Node bf x subtree_1 subtree_2)
      | (val == x) = True
      | (val < x) = (member val subtree_1)
      | (val > x) = (member val subtree_2)
   
   -- how many elements are there in the Set?
   cardinality :: Set a -> Int
   cardinality (Empty) = 0
   cardinality tree = countNodes tree 0
   
   -- apply a function to every element in the Set
   setmap :: (Ord b) => (a -> b) -> Set a -> Set b
   setmap f (Empty) = Empty
   setmap f tree = fromList (map f (toListNoOrd tree))
   
   -- right fold a Set using a function *f*
   setfoldr :: (a -> b -> b) -> Set a -> b -> b
   setfoldr f (Empty) acc = acc
   setfoldr f (Node bf x subtree_1 subtree_2) acc = setfoldr f subtree_2 (f x (setfoldr f subtree_1 acc))
   
   -- remove an element *x* from the set
   -- return the set unaltered if *x* is not present
   removeSet :: (Eq a) => a -> Set a -> Set a
   removeSet target (Empty) = Empty
   removeSet target tree = fromListNoOrd (removeFrom target (toListNoOrd tree)) 

   removeSet2 :: (Eq a) => a -> Set a -> Set a
   removeSet2 target (Empty) = Empty
   removeSet2 target (Node bf x subtree_1 subtree_2)
      | (target == x) = fromListNoOrd (removeFrom target (toListNoOrd (Node bf x subtree_1 subtree_2)))
      | otherwise = (createNode x (removeSet2 target subtree_1) (removeSet2 target subtree_2))

   -- powerset of a set
   -- powerset {1,2} => { {}, {1}, {2}, {1,2} }
   altPowerSet :: Set a -> Set (Set a)
   altPowerSet s = setOfSets $ combin $ toListNoOrd $ s

   powerSet :: Set a -> Set (Set a)  -- This version is marginally more efficient (I think?)
   powerSet s = setOfSets $ altCombs $ toListNoOrd $ s
   
   {-
      ON MARKING:
   
      Be careful! This coursework will be marked using QuickCheck, against
      Haskell's own Data.Set implementation. This testing will be conducted
      automatically via a marking script that tests for equivalence between your
      output and Data.Set's output. There is no room for discussion, a failing test
      means that your function does not work properly: you do not know better than
      QuickCheck and Data.Set! Even one failing test means 0 marks for that
      function. Changing the interface by renaming functions, deleting functions,
      or changing the type of a function will cause the script to fail to load in
      the test harness. This requires manual adjustment by a TA: each manual
      adjustment will lose 10% from your score. If you do not want to/cannot
      implement a function, leave it as it is in the file (with undefined).
   
      Marks will be lost for too much similarity to the Data.Set implementation.
   
      Pass: creating the Set type and implementing toList and fromList is enough
      for a passing mark of 40%, as long as both toList and fromList satisfy the
      toFromListProp function.
   
      The maximum mark for those who use Haskell lists to represent a Set is 70%.
      To achieve a higher grade than is, one must write a more efficient
      implementation. 100% is reserved for those brave few who write their own
      self-balancing binary tree.
   -}
   
