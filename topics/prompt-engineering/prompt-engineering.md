> TL;DR Prompt engineering is iteratively finding the best input 
so the LLM’s output is more accurate and reliable.


## What is it

In Generative AI, you instruct an LLM to create something. 
Most of the time, the output is text, but it can also be images, audio, or video.
The instruction you provide is called the **prompt**. 

It's like the input you give to an LLM to respond with a result. The flow is simple:

```text
PROMPT (input) → LLM → ANSWER (output)
```


But the *quality* of that answer depends a lot on how you write the prompt.


Same model, two different instructions:

**Vague**

```text
Explain database index.
```

A typical reply might look like this:

```text
A database index is a data structure that improves the speed of
data retrieval operations on a database table at the cost of
additional writes and storage space. Indexes can be created using
one or more columns, providing the basis for both rapid random
lookups and efficient access of ordered records. There are several
types of indexes, including B-tree, hash, bitmap, and full-text
indexes. Choosing the right index depends on the query patterns,
data distribution, and the database engine in use. Over-indexing
can slow down inserts and updates, so indexes should be designed
carefully as part of schema and query optimization...
```

The problem: it is long, hard to read, and not aimed at anyone in particular.


**Clearer**

```text
Explain what a database index is in one short paragraph,
for a junior engineer who knows SQL basics.
```

A clearer reply might look like this:

```text
A database index is like a book's index for a table: it helps the
database find rows matching a WHERE or JOIN without scanning every
row. The trade-off is cost on writes. Every INSERT, UPDATE, or DELETE
may also update the index, and indexes use disk space. For a junior
engineer, start by indexing columns you filter or join on often —
and avoid indexing everything "just in case."
```

The second one is more likely to get a useful answer, not because the model changed,
but because the instruction was clearer. 

That's where prompt engineering starts!

> Prompt engineering is the process of crafting effective instructions given to an LLM to produce better results.

This process is **iterative**. 
Change one thing, compare outputs, keep what works, 
and stop when you finally find the proper recipe for the task.


## Key parts

The main components of a prompt are the following:

- **Role:** who the model should act as (its persona)
- **Instruction:** the main task/directive, what should be done
- **Context:** background information, relevant facts
- **Examples:** one or two short samples of what the answer should be like
- **Output Format:** how the response is structured and presented

Each of them has a specific role that helps the LLM produce effective answers.

Not all of these elements appear in every prompt. 
They are not always clearly separated from each other. 
Sometimes one part implies another. For example, a JSON example also sets the output format.




## A simple pattern


```text
## Role
You are a [role].

## Task
[instruction]

## Context
- [key fact 1]
- [key fact 2]

## Examples
- [Example 1] -> Response
- [Example 2] -> Response

## Output format
[format]
```

Here is the same pattern filled in:

```text
## Role
You are a Michelin-grade chef.

## Task
I'll give you a dish name. Reply with the ingredients and
the recipe steps.

## Context
My preferences:
- I like spicy food.
- Keep servings for 2 people.

## Examples
Input: Spicy tomato pasta
Output:
Ingredients:
- 200g spaghetti
- 2 garlic cloves, minced
- 1 tsp chili flakes
- 1 can crushed tomatoes
- 1 tsp salt
- 30ml olive oil

Steps:
1. Boil the pasta in salted water until al dente.
2. Soften the garlic in olive oil, then add chili flakes.
3. Stir in the tomatoes, simmer 8–10 minutes, season.
4. Toss with the drained pasta and serve hot.

## Output format
Answer only with the ingredients as a bullet list and then Steps as a numbered list.
```

## A few tips

- Start with simple prompts, add context as you go
- Give clear and specific instructions
- Include only relevant context
- Prefer saying what to do over what not to do
- Include examples to define expected answers
- Use roles to add expertise
- Reorder components to guide what the LLM pays attention to


**Note**: Check each model’s docs for prompting guidance. What works best depends on how that model was trained.

## Conclusion

Prompt quality often matters as much as the model. 
Prompt engineering helps you find that quality.

