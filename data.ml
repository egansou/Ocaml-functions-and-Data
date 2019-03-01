open Funs

(********************************)
(* Part 1: High Order Functions *)
(********************************)

let count e lst = 
	fold (fun acc h -> if e = h then acc + 1 else acc) 0 lst

let divisible_by n lst =  
	map (fun x -> if n = 0 then false else x mod n = 0) lst

let divisible_by_first lst = 
	match lst with
	|[] -> []
	| h::t -> map (fun x -> x mod h = 0) lst

let pairup_one x lst2 = fold_right (fun t acc -> (x, t) :: acc ) lst2 []

let pairup lst1 lst2 = fold_right (fun t acc -> append (pairup_one t lst2) acc ) lst1 []

let concat_lists lst = fold_right (fun t acc -> append  t acc) lst []

(***********************)
(* Part 2: Integer BST *)
(***********************)

type int_tree =
    IntLeaf
  | IntNode of int * int_tree * int_tree

let empty_int_tree = IntLeaf

let rec int_insert x t =
    match t with
      IntLeaf -> IntNode(x,IntLeaf,IntLeaf)
    | IntNode (y,l,r) when x > y -> IntNode (y,l,int_insert x r)
    | IntNode (y,l,r) when x = y -> t
    | IntNode (y,l,r) -> IntNode(y,int_insert x l,r)

let rec int_mem x t =
    match t with
      IntLeaf -> false
    | IntNode (y,l,r) when x > y -> int_mem x r
    | IntNode (y,l,r) when x = y -> true
    | IntNode (y,l,r) -> int_mem x l

(* Implement the functions below. *)

let rec int_size t = match t with
	IntLeaf -> 0
  | IntNode (_, l, r) -> int_size l + int_size r + 1  

let rec int_max t = match t with 
	IntLeaf -> raise (Invalid_argument("int_max"))
  | IntNode (y, _, r) -> if r = empty_int_tree then y else int_max r

let rec int_insert_all lst t = 
	(*fold (fun acc head ->  int_insert head t) t lst*)
	match lst with 
	[] -> t
  | head :: tail  -> int_insert_all tail (int_insert head t)

let rec int_as_list t = match t with
	IntLeaf -> []
  | IntNode(y,l,r) -> append (int_as_list l) (y :: int_as_list r)

let rec int_common t x y = 
	if (int_mem x t && int_mem y t) then match t with
	  	  IntLeaf -> raise (Invalid_argument("int_common"))
    	| IntNode (e,l,r) when e < x && e < y -> int_common r x y
    	| IntNode (e,l,r)  when e > x && e > y -> int_common l x y
    	| IntNode (e,_,_) -> e
	else raise (Invalid_argument("int_common"))

(***************************)
(* Part 3: Polymorphic BST *)
(***************************)

type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
type 'a compfn = 'a -> 'a -> int
type 'a ptree = 'a compfn * 'a atree

let empty_ptree f : 'a ptree = (f,Leaf)

(* Implement the functions below. *)

let rec insert_helper x (func, t) =
	 match t with
      Leaf -> Node(x,Leaf,Leaf)
    | Node (y,l,r) when func x y > 0 -> Node (y,l, insert_helper x (func, r))
    | Node (y,l,r) when func x y = 0 -> t
    | Node (y,l,r) -> Node(y, insert_helper x (func, l), r)

let pinsert x t = match t with (a,b) -> (a, insert_helper x (a,b))
 
let rec mem_helper x (func, t) = 
	 match t with
      Leaf -> false
    | Node (y,l,r) when func x y > 0 -> mem_helper x (func, r)
    | Node (y,l,r) when func x y = 0 -> true
    | Node (y,l,r) -> mem_helper x (func, l)   

let pmem x t = mem_helper x t 

(*******************************)
(* Part 4: Graphs with Records *)
(*******************************)

type node = int
type edge = { src : node; dst : node; }
type graph = { nodes : int_tree; edges : edge list; }

let empty_graph = {nodes = empty_int_tree; edges = [] }

let add_edge e { nodes = ns; edges = es } =
    let { src = s; dst = d } = e in
    let ns' = int_insert s ns in
    let ns'' = int_insert d ns' in
    let es' = e::es in
    { nodes = ns''; edges = es' }

let add_edges es g = fold (fun g e -> add_edge e g) g es

(* Implement the functions below. *)

let graph_empty g = (g = empty_graph) 

let graph_size g = int_size g.nodes

let is_dst n e = (e.dst = n)

let src_edges n g = fold (fun acc head -> if head.src = n then head :: acc else acc ) [] g.edges


let rec find_nodes n g lst visited_tree =  
     match lst with 
       [] -> if (int_mem n g.nodes) then n::[] else [] 
       |h::t -> if int_mem h.src visited_tree &&  int_mem h.dst visited_tree
       				then find_nodes n g t visited_tree
       			else h.src :: h.dst :: find_nodes n g (append t (src_edges h.dst g)) (int_insert_all [h.src; h.dst] visited_tree)

let reachable n g = fold (fun acc head -> (int_insert head acc) ) IntLeaf (find_nodes n g (src_edges n g) IntLeaf) 
 
