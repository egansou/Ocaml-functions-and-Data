# Project: OCaml Higher Order Functions and Data

For this project, Library functions found in the [`Pervasives` module][pervasives doc] and the functions provided in `funs.ml`. 

Introduction
------------
The goal of this project is to increase familiarity with programming in OCaml using higher order functions and user-defined types. 

Project Files
-------------

## OCaml Files
  - **data.ml**: This is where you will write your code for all parts of the project. All other files will be discarded.
  - **data.mli**: This file is used to describe the signature of all the functions in the module. Don't worry about this file, but make sure it exists or your code will not compile. It also contains our type definitions.
  - **funs.ml** and **funs.mli**: These files contain definitions for map, fold, length, and reverse.
  - **public.ml**: This file contains all of the public test cases.
  - **Makefile**: This is used to build the public tests by simply running the command `make`.


Part 1: High Order Functions
------------------------
Write the following functions using `map`, `fold`, or `fold_right` as defined in the file `funs.ml`.

#### count e lst
- **Type**: `'a -> 'a list -> int`
- **Description**: Returns how many times the element `e` occurs in `lst`.
- **Examples:**
```
count 3 [1;3;1;1;3] = 2
count "hello" ["there";"ralph"] = 0
```

#### divisible_by n lst
- **Type**: `int -> int list -> bool list`
- **Description**: Returns a list of booleans where each boolean represents if the corresponding element of `lst` is divisible by `n`. Take note that 0 is divisible by 0.
- **Examples:**
```
divisible_by 2 [1;3;4;8;0] = [false;false;true;true;true]
```

#### divisible_by_first lst
- **Type**: `int list -> bool list`
- **Description**: Returns a list of booleans where each boolean represents if the corresponding element of `lst` is divisible by the first element of `lst`. Take note that 0 is divisible by 0.
- **Examples:**
```
divisible_by_first [2;3;4;8;0] = [true;false;true;true;true]
divisible_by_first [2] = [true]
divisible_by_first [] = []
```

#### pairup lst1 lst2
- **Type**: `'a list -> 'b list -> ('a * 'b) list`
- **Description**: Returns a list of tuples containing every possible combination of elements from `lst1` and `lst2` and nothing more.
- **Examples:**
```
pairup [] [] = []
pairup [1;2] [3;4;5] = [(1, 3); (1, 4); (1, 5); (2, 3); (2, 4); (2, 5)]
```

#### concat_lists lst
- **Type**: `'a list list -> 'a list`
- **Description**: Returns a list consisting of the elements of `lst` concatenated together. Note that only the top level of lists is concatenated, whereas List.flatten concatenates all levels.
- **Examples:**
```
concat_lists [[1;2];[7];[5;4;3]] = [1;2;7;5;4;3]
concat_lists [[[1;2;3];[2]];[[7]]] = [[1;2;3];[2];[7]]
```

Part 2: Integer BST
--------------------------------
Write functions that will operate on a binary search tree whose nodes contain integers. Provided below is the type of `int_tree`.

```
type int_tree =
    IntLeaf
  | IntNode of int * int_tree * int_tree
```

According to this definition, an ``int_tree`` is either: empty (just a leaf), or a node (containing an integer, left subtree, and right subtree). An empty tree is just a leaf.

```
let empty_int_tree = IntLeaf
```

Like lists, BSTs are immutable. Once created we cannot change it. To insert an element into a tree, create a new tree that is the same as the old, but with the new element added. Let's write `insert` for our `int_tree`. Recall the algorithm for inserting element `x` into a tree:

- *Empty tree?* Return a single-node tree.
- `x` *less than the current node?* Return a tree that has the same content as the present tree but where the left subtree is instead the tree that results from inserting `x` into the original left subtree.
- `x` *already in the tree?* Return the tree unchanged.
- `x` *greater than the current node?* Return a tree that has the same content as the present tree but where the right subtree is instead the tree that results from inserting `x` into the original right subtree.

Here's one implementation:

```
let rec int_insert x t =
  match t with
    IntLeaf -> IntNode (x, IntLeaf, IntLeaf)
  | IntNode (y, l, r) when x < y -> IntNode (y, int_insert x l, r)
  | IntNode (y, l, r) when x = y -> t
  | IntNode (y, l, r) -> IntNode (y, l, int_insert x r)
```

**Note**: The `when` syntax acts as an extra guard in addition to the pattern. For example, `IntNode (y, l, r) when x < y` will only be matched when the tree is an `IntNode` and `x < y`. This serves a similar purpose to having an if statement inside of the general `IntNode` match case, but allows for more readable syntax in many cases.

Let's try writing a function which determines whether a tree contains an element. This follows a similar procedure except we'll be returning a boolean if the element is a member of the tree.

```
let rec int_mem x t =
  match t with
    IntLeaf -> false
  | IntNode (y, l, r) when x < y -> int_mem x l
  | IntNode (y, l, r) when x = y -> true
  | IntNode (y, l, r) -> int_mem x r
```

Write the following functions which operate on `int_tree`.

#### int_size t
- **Type**: `int_tree -> int`
- **Description**: Returns the number of nodes in tree `t`.
- **Examples:**
```
int_size empty_int_tree = 0
int_size (int_insert 1 (int_insert 2 empty_int_tree)) = 2
```

#### int_max t
- **Type**: `int_tree -> int`
- **Description**: Returns the maximum element in tree `t`. Raises exception `Invalid_argument("int_max")` on an empty tree. This function should be O(height of the tree).
- **Examples:**
```
int_max (int_insert_all [1;2;3] empty_int_tree) = 3
```

#### int_insert_all lst t
- **Type**: `int list -> int_tree -> int_tree`
- **Description**: Returns a tree which is the same as tree `t`, but with all the integers in list `lst` added to it. Try to use fold to implement this in one line.
- **Examples:**
```
int_as_list (int_insert_all [1;2;3] empty_int_tree) = [1;2;3]
```

#### int_as_list t
- **Type**: `int_tree -> int list`
- **Description**: Returns a list where the values correspond to an [in-order traversal][wikipedia inorder traversal] on tree `t`.
- **Examples:**
```
int_as_list (int_insert 2 (int_insert 1 empty_int_tree)) = [1;2]
int_as_list (int_insert 2 (int_insert 2 (int_insert 3 empty_int_tree))) = [2;3]
```

#### int_common t x y
- **Type**: `int_tree -> int -> int -> int`
- **Description**: Returns the closest common ancestor of `x` and `y` in the tree `t` (i.e. the lowest shared parent in the tree). Raises exception `Invalid_argument("int_common")` on an empty tree or where `x` or `y` don't exist in tree `t`.
- **Examples:**
```
let t = int_insert_all [6;1;8;5;10;13;9;4] empty_int_tree;;
int_common t 1 10 = 6
int_common t 8 9 = 8
```

Part 3: Polymorphic BST
---------------------------------
Our type `int_tree` is limited to integer elements. We want to define a binary search tree over *any* totally ordered type. Let's define the type `'a atree` to do so.

```
type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
```

This defintion is the same as `int_tree` except it's polymorphic. The nodes may contain any type `'a`, not just integers. Since a tree may contain any value, we need a way to compare values. We define a type for comparison functions.

```
type 'a compfn = 'a -> 'a -> int
```

Any comparison function will take two `'a` values and return an integer. If the integer is negative, the first value is less than the second; if positive, the first value is greater; if 0 they're equal.

Finally, we can bundle the two previous types to create a polymorphic BST.

```
type 'a ptree = 'a compfn * 'a atree
```

An empty tree is just a leaf and some comparison function.

```
let empty_ptree f : 'a ptree = (f, Leaf)
```

Modify the code from your `int_tree` functions to implement some functions on `ptree`. Remember to use the bundled comparison function!

#### pinsert x t
- **Type**: `'a -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with `x` added to it.
- **Examples:**
```
let int_comp x y = if x < y then -1 else if x > y then 1 else 0;;
let t0 = empty_ptree int_comp;;
let t1 = pinsert 1 (pinsert 8 (pinsert 5 t0));;
```

#### pmem x t
- **Type**: `'a -> 'a ptree -> bool`
- **Description**: Returns true iff `x` is an element of tree `t`.
- **Examples:**
```
(* see definitions of t0 and t1 above *)
pmem 5 t0 = false
pmem 5 t1 = true
pmem 1 t1 = true
pmem 2 t1 = false
```

Part 4: Graphs with Records
--------------------------------------
For the last part of the project, I implement functions which operate on graphs.

Here are the types for graphs. They use OCaml's record syntax.

```
type node = int
type edge = { src: node; dst: node; }
type graph = { nodes: int_tree; edges: edge list }
```

A graph is record with two fields: a set of nodes aptly called "nodes" (represented as an `int_tree`), and a list of edges. A node is represented as an integer, and an edge is a record identifying its source and destination nodes.

An empty graph has no nodes (i.e., the empty integer tree) and has no edges (the empty list).

```
let empty_graph = { nodes = empty_int_tree; edges = [] }
```

Provided below is a function which adds an edge to a graph. Its type is `edge -> graph -> graph`.

```
let add_edge e { nodes = ns; edges = es } =
  let { src = s; dst = d } = e in
  let ns' = int_insert s ns in
  let ns'' = int_insert d ns' in
  let es' = e::es in
  { nodes = ns''; edges = es' }
```

Given an edge `e` and graph `g`, it returns a new graph that is the same as `g`, but with `e` added. Note this routine makes no attempt to eliminate duplicate edges; these could add some inefficiency, but should not harm correctness.

We also provide a function `add_edges : edge list -> graph -> graph` to add multiple edges at once.

Write the following functions which operate on `graph`.

#### graph_empty g
- **Type**: `graph -> bool`
- **Description**: Returns true iff graph `g` is empty.
- **Examples:**
```
graph_empty (add_edge { src = 1; dst = 2 } empty_graph) = false
graph_empty empty_graph = true
```

#### graph_size g
- **Type**: `graph -> int`
- **Description**: Returns the number of nodes in graph `g`.
- **Examples:**
```
graph_size (add_edge { src = 1; dst = 2 } empty_graph) = 2
graph_size (add_edge { src = 1; dst = 1 } empty_graph) = 1
```

#### is_dst n e
- **Type**: `node -> edge -> bool`
- **Description**: Returns true iff node `n` is the destination of edge `e`.
- **Examples:**
```
is_dst 1 { src = 1; dst = 2 } = false
is_dst 2 { src = 1; dst = 2 } = true
```

#### src_edges n g
- **Type**: `node -> graph -> edge list`
- **Description**: Returns a list of edges in graph `g` whose source node is `n`.
- **Examples:**
```
src_edges 1 (add_edges [{src=1;dst=2}; {src=1;dst=3}; {src=2;dst=2}] empty_graph) = [{src=1;dst=2}; {src=1;dst=3}]
```

#### reachable n g
- **Type**: `node -> graph -> int_tree`
- **Description**: Returns the set of nodes reachable from node `n` in graph `g`, where the set is represented as an `int_tree`. If `n` is neither a source nor a destination in the graph, `IntLeaf` should be returned.
- **Examples:**
```
int_as_list
 (reachable 1
   (add_edges [{src=1;dst=2}; {src=1;dst=3}; {src=2;dst=2}] empty_graph)) =
   [1;2;3]

int_as_list
 (reachable 3
   (add_edges [{src=1;dst=2}; {src=1;dst=3}; {src=2;dst=2}] empty_graph)) =
   [3]

int_as_list
 (reachable 2
   (add_edges [{src=0;dst=1}] empty_graph)) =
   []
```



<!-- These should always be left alone or at least updated -->
[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[wikipedia inorder traversal]: https://en.wikipedia.org/wiki/Tree_traversal#In-order
