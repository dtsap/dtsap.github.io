> TL;DR Prompt engineering has many techniques, and you use them to get better model outputs. 
Start with one, move to another, or mix them. Stop when results are good enough.


## Categorization

There are already a few different taxonomies of prompting techniques.
I mostly like to separate them on what changes in the prompt,
how the LLM is thinking, how many steps the process takes, 
and whether other tools are required. 

- **Content**: what you put in the prompt (examples, hints, retrieved docs)
- **Reasoning**: how the model thinks (steps, plans, branches)
- **Multi-step**: whether the process takes more than one step (chains, votes, refine loops, retrieval, running code)
- **Tools**: whether tools/code are involved

Most techniques combine a few of these primitives, and a technique can belong to more than one.

## The techniques
> Treat the list as incomplete. Some are missing, and new ones keep arriving.

| Technique | Content | Reasoning | Multi-step | Tools |
| --- | :---: | :---: | :---: | :---: |
| **Zero-shot**<br>Ask the model to do the task with no examples in the prompt. | ✓ | | | |
| **Few-shot**<br>Include one (one-shot) or more (few-shot) input→output examples, so the model can follow the pattern. | ✓ | | | |
| **Chain-of-Thought**<br>Ask the model to show step-by-step reasoning before the final answer. | | ✓ | | |
| **Plan-and-Solve**<br>First ask the model for a plan, then have it carry out that plan to reach the answer. | | ✓ | | |
| **Skeleton-of-Thought**<br>First produce a short outline, then expand each point in parallel into the full answer. | | ✓ | ✓ | |
| **Directional Stimulus Prompting**<br>Have a model generate short hint tokens (like keywords), then add them to the prompt to steer the answer. | ✓ | | ✓ | |
| **Meta Prompting**<br>Use the LLM to write or improve prompts for another task. | ✓ | | ✓ | |
| **Prompt Chaining**<br>Split a hard task into smaller prompts, run them in order, and combine the results. | | | ✓ | |
| **Least-to-Most**<br>Break the problem into easier subproblems and solve them in order from simplest to hardest. | | ✓ | ✓ | |
| **Self-Ask**<br>Have the model raise follow-up questions, answer them with search, then give the final response. | | ✓ | ✓ | ✓ |
| **Self-consistency**<br>Sample several reasoning paths, then pick the answer that appears most often. | | ✓ | ✓ | |
| **Self-Refine**<br>Have the model critique its own answer and rewrite it in a loop until it is good enough. | | ✓ | ✓ | |
| **Chain-of-Verification (CoVe)**<br>Draft an answer, generate verification questions, answer those, then revise the original answer. | | ✓ | ✓ | |
| **Reflexion**<br>Let the model act with tools, critique its own attempt, store that feedback, and retry with the lesson learned. | | ✓ | ✓ | ✓ |
| **Generated Knowledge Prompting**<br>First have the model generate useful background knowledge, then feed that into a second prompt with the real task. | ✓ | | ✓ | |
| **RAG**<br>Retrieve relevant documents from an external store (often embeddings + a vector DB), then add them to the prompt as context. | ✓ | | ✓ | |
| **Active-Prompt**<br>Use uncertainty to pick which few-shot examples a human should annotate, then add those to the prompt. | ✓ | | ✓ | |
| **Auto-CoT**<br>Automatically generate diverse chain-of-thought examples instead of writing the demos by hand. | ✓ | ✓ | ✓ | |
| **Automatic Prompt Engineer**<br>Have the model propose many candidate prompts, score them on examples, and keep the best. | ✓ | | ✓ | |
| **Multimodal CoT**<br>Generate a rationale from text and other inputs (like images), then use that rationale to reach the answer. | ✓ | ✓ | ✓ | |
| **Tree of Thoughts**<br>Explore several reasoning branches, evaluate them, and pick or continue the most promising path. | | ✓ | ✓ | |
| **Graph of Thoughts**<br>Like Tree of Thoughts, but thoughts can merge and reuse connections as a graph, not only a tree. | | ✓ | ✓ | |
| **Graph Prompting**<br>Put a knowledge graph or a task graph into the prompt, and ask the model to use those links. | ✓ | | | |
| **ReAct**<br>Interleave reasoning with actions (tool calls) and observations until the task is done. | | ✓ | ✓ | ✓ |
| **Program-Aided Language Models (PAL)**<br>Have the model write code for the hard parts, run it, and use the program output in the answer. | | ✓ | ✓ | ✓ |
| **Automatic Reasoning and Tool Use (ART)**<br>Keep worked examples of multi-step reasoning that call tools, then reuse that pattern on new tasks. | ✓ | ✓ | ✓ | ✓ |


## Example

**Zero-shot.**

Ask only that.

```text
A notebook costs $3 more than a pen.
Together they cost $11.
How much does the pen cost?
```

A rushed reply might be:

```text
The pen costs $8.
```

That subtracts $3 from $11 and stops. You get a number, and the mistake is hidden.

**Chain-of-Thought.** 

Add one line so the model shows its steps. This is the Reasoning primitive, still in one call.

```text
A notebook costs $3 more than a pen.
Together they cost $11.
How much does the pen cost?

Show the steps, then give the price.
```

The reply could look like this:

```text
Let the pen cost x.
The notebook costs x + 3.
x + (x + 3) = 11
2x + 3 = 11
2x = 8
x = 4

The pen costs $4.
```

**Program-Aided Language Models.**

The model writes that equation as code, you run it, and the program's number is the answer. This adds Multi-step and Tools.

```text
x = (11 - 3) / 2
print(x)
```

That costs another call and a run. Use it when the steps still look wrong.

The steps above already hold. On this task, the reasoning step was enough.

## Conclusion

No single technique is a silver bullet. Try them, depending on the task and the available tools you have. 
Observe and evaluate the responses. Then go with the most effective.
