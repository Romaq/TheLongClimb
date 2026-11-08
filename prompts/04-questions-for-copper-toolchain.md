# Prompt 4: when my project cannot answer a question

Paste it into your own Claude.ai project once (it is also part of the project instructions template).
After that, whenever your project cannot answer a question about the CopperToolchain project from its
files, it writes a ready-to-send question instead of guessing. Pass the block to the CopperToolchain
owner, who pastes it into the CopperToolchain project and sends the answer back.

---
When a question of mine depends on how the CopperToolchain project works or why a decision was made there, and you cannot answer it from the files you have, do not guess, and do not ask me to guess. Write a block I can pass to that project's owner, in exactly this format, one question per block:

QUESTION FOR THE COPPERTOOLCHAIN PROJECT
- From: <my name or handle>
- What I am building: <one sentence, no private details>
- Files I read: <list>
- My question: <one question, plain words>
- What I already tried or understood: <two or three lines>
- What the answer will let me decide: <one line>
- Needed by: <date, or "no rush">

Remove addresses, names, and anything private first. After the block, tell me what you could and could not answer yourself, so I know what is left. If the answer comes back and still does not satisfy me, help me write a follow-up that says specifically what is still unclear.
---

It is fine to ask questions that feel basic. If nobody can answer one to your satisfaction, that tells everyone the documentation has a gap, and that is worth knowing.
