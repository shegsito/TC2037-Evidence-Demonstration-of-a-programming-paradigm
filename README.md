# TC2037 — Evidence of a Programming Paradigm

Evidence 3 

Paradigm chosen: Functional

Language: Racket 

Student: Germán Uriel Xochihua Moncada A01614712

Implementation of Computational Methods

---

## 1. Description

**Source:** [Codeforces 580A — Kefa and First Steps](https://codeforces.com/problemset/problem/580/A)

Kefa tracks his daily earnings over `n` days. He wants to know the length of the longest **non-decreasing subsegment** — a continuous fragment where each value is greater than or equal to the previous one.

**Example:**

| Input | Output | Explanation |
|---|---|---|
| `2 2 1 3 4 1` | `3` | Subsegment `1 3 4` has length 3 |
| `2 2 9` | `3` | The entire array is non-decreasing |

**Constraints:**
- `1 ≤ n ≤ 10^5`
- `1 ≤ ai ≤ 10^9`

### Real World Context

This problem models a pattern that appears in several real applications:

- **Stock market analysis:** determine what's the longest continuous frowth streak in daily prices, which is a key signal in trend-following strategies.

- **Performance monitoring:** detecting que longest uninterrupted improvment period in system metrics.

- **Data quality checks:** finding the longest ordered run in a sequence to validate is a sensor is behaving correctly.

---

## 2. Model

The functional paradigm is done in **lambda calculus**, a formal system made by Alonzo Church (1936) for expressing computation through function application and substitution. Languages like Haskell, Lisp, Javascript and Racket are descendants of this model: every computation is a pure function that takes inputs and returns outputs with no observable side effects (Felleisen et al., 2018).

This problem is a particularly strong fit for the functional paradigm. The solution requires traversing a list while tracking three pieces of state: the previous element, the current segment length, and the best segment found so far. In the functional paradigm, this state is captured in an **immutable accumulator** a single value that is passed from one step to the next through `foldl`, never mutated.

This is the core argument for functional programming here: instead of updating scattered mutable variables inside a loop, the state is captured in a single immutable accumulator that is explicitly passed from step to step. This is what makes `foldl` powerful — the traversal becomes a sequence of pure function calls, making the logic easier to follow, test, and verify.

The key properties that make this problem ideal for functional programming:

- The transversal is a **pure fold**: each step is a function of ONLY the current element and the accumulated state.

- The accumulator is **inmutable**: each call to `step` returns a new value insted of modifying thr old one.

- The solution is expressed as fold step initial-accumulator list. Just one line captures the entire

- NO mutable variables, loops or counters.

### Pipeline Diagram

![figure1](/img/Pipelinediagram.jpg.jpeg)

*Figure 1. foldl applies step at each position threading the accumulator through the list*

### How Is the Functional Paradigm Used?

* **Pure function:** `step` same accumulator + element always produce the same result, no side effects

* **Higher-order function:** `foldl` takes `step` as a first-class argument

* **First-class function:** `step` is passed directly to `foldl` as a value

* **Immutable accumulator:** `(list prev curr best)` i never mutated, each call returns a new list.

* **No mutation:** No variables are reassigned at any point.

### Abstract Representation

```
Initial accumulator: (list 2 1 1)   ; prev=2, curr=1, best=1

step 2 '(2 1 1)  →  '(2 2 2)       ; 2 >= 2, curr=2, best=2
step 1 '(2 2 2)  →  '(1 1 2)       ; 1 < 2,  reset, best=2
step 3 '(1 1 2)  →  '(3 2 2)       ; 3 >= 1, curr=2, best=2
step 4 '(3 2 2)  →  '(4 3 3)       ; 4 >= 3, curr=3, best=3
step 1 '(4 3 3)  →  '(1 1 3)       ; 1 < 4,  reset, best=3

Result: (third '(1 1 3)) → 3
```

*Figure 2. The accumulator evolves at each step, it does not mutate it is always replaced*

---

## 3. Implementation

### Racket

```racket

;; The accumulator is a list: (list prev curr best)
;; prev - previous element
;; curr - length of current non-decreasing segment
;; best - longest segment found so far


;; step: Number (List Number Number Number) -> (List Number Number Number)
;; Pure function: fold passes (element accumulator), returns updated accum


(define (step x acc)
  (let ([prev (first acc)]
        [curr (second acc)]
        [best (third acc)])
    (if (<= prev x)
        (list x (+ curr 1) (max best (+ curr 1))) ; segment continues
        (list x 1 best))))

;; solve : (Listof Number) -> Number
;; Returns the length of the longest non-decreasing subsegment

(define (solve lst)
  (if (null? lst)
      0
      (third
       (foldl step
              (list (first lst) 1 1) ;; initial accum
              (rest lst))))) ; fold over remaining elements
```
This is a natural functional solution as we use `fold`as a **high-order function** that recives `step` as a first-class argument. The accumulator is **never mutated**, the `step` calls returns a new list. Comparying it into a imperative solution, there are no modified shared variables.

---

## 4 Test.

Tests call `solve` directyl with different inputs. Run the file and it'll print the output of each test case.

```racket
(solve '(2 2 1 3 4 1))       ; expected: 3
(solve '(2 2 9))             ; expected: 3
(solve '(1))                 ; expected: 1
(solve '(1 2 3 4 5))         ; expected: 5
(solve '(5 4 3 2 1))         ; expected: 1
(solve '(1 1 1 1))           ; expected: 4
(solve '(3 1 2 1 2 3))       ; expected: 3
(solve '(1 3 2 4 3 5))       ; expected: 2
(solve '())                  ; expected: 0
```

| Test | Input | Expected | Output | Result |
|---|---|---|---|---|
| Example 1 from problem | `'(2 2 1 3 4 1)` | `3` | `3` |  Pass |
| Example 2 from problem | `'(2 2 9)` | `3` | `3` |  Pass |
| Single element | `'(1)` | `1` | `1` |  Pass |
| Fully non-decreasing | `'(1 2 3 4 5)` | `5` | `5` |  Pass |
| Fully decreasing | `'(5 4 3 2 1)` | `1` | `1` |  Pass |
| All equal | `'(1 1 1 1)` | `4` | `4` |  Pass |
| Multiple segments | `'(3 1 2 1 2 3)` | `3` | `3` |  Pass |
| Alternating | `'(1 3 2 4 3 5)` | `2` | `2` |  Pass |
| Empty list | `'()` | `0` | `0` |  Pass |


All 9 test succesfully passed 

---

## 5. Analysis

### Time Complexity

**Let `n` = number of elements in the list.**

| Operation | Cost |
|---|---|
| `foldl` over `n` elements | O(n) — one pass |
| `step` per element | O(1) — list access, comparison, max |
| `first`, `second`, `third` | O(1) — fixed-position list access |
| **Total** | **O(n)** |

The overall complexity is **O(n)** — a single linear pass over the list with O(1) work per element.

### Space Complexity

| | Cost |
|---|---|
| Accumulator per step | O(1) fixed-size list of 3 values |
| Call stack (`foldl` is iterative) | O(1) |
| **Total** | **O(1)** |

`foldl` in Racket is iterative, it does not build a call stack proportional to the list length. This means the solution uses constant auxiliary space, which is very efficient and optimal.

### Other Paradigms & Tradeoffs

Prolog is a logic programming language covered in this course. Instead of defining how to compute a result step by stepm you declare rules with relationships that the prolog's engine should resolve them through unification and backtracking (Clocksin & Mellish, 2003).

///////////////////////////////////
INSERT THE PROLOG CODE AND QUERY
///////////////////////////////////

#### Paradigm Comparison

| | Functional (Racket) | Logic (Prolog) |
|---|---|---|
| **Core mechanism** | `foldl` with immutable accumulator | Recursive rules with pattern matching |
| **Mutation** | None | None |
| **Time complexity** | O(n) | O(n) |
| **Space complexity** | O(1) — `foldl` is iterative | O(n) — recursive call stack |

Both paradigms produce indentical results with the same time complexity. The functional version has a space advantage because of fold iterative function in Racket, while the Prolog solution builds a call stack of depth `n`. More importantly, the functional version expresses the algorithm more directly.

---

## Bibliography

Church, A. (1936). An unsolvable problem of elementary number theory. *American Journal of Mathematics, 58*(2), 345–363. https://doi.org/10.2307/2371045

Clocksin, W. F., & Mellish, C. S. (2003). *Programming in Prolog* (5th ed.). Springer. https://doi.org/10.1007/978-3-642-55481-0

Felleisen, M., Findler, R. B., Flatt, M., & Krishnamurthi, S. (2018). *How to Design Programs* (2nd ed.). MIT Press. https://htdp.org

Hudak, P. (1989). Conception, evolution, and application of functional programming languages. *ACM Computing Surveys, 21*(3), 359–411. https://doi.org/10.1145/72551.72554

GeeksforGeeks. (2025, November 15). *Functional Programming Paradigm*. https://www.geeksforgeeks.org/blogs/functional-programming-paradigm/

Aguirre, B. (2025). *Lambda Calculus Functional Paradigm*. https://docs.google.com/document/d/1w8DCXQ4cQPdcDPQOVN3Hn65X000V0oixgOatseDyvUE/edit?usp=sharing