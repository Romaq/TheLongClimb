# Surveys: evaluating skills against goals

Purpose: a dispassionate, evidence-based picture of current skills measured against personal
goals, so that learning and projects can be steered. The survey templates are public; your
answers are not.

## Process

1. **Survey 1, goals** (`01-goals.md`): what you want, by when, and what "done" looks like.
2. Copy it to the private folder and fill it in there:

       mkdir -p surveys/responses
       cp surveys/01-goals.md surveys/responses/01-goals-$(date +%F).md

3. **Upload the filled copy directly to Claude in chat** (attach the file). Do not paste it
   into the logged conversation and do not commit it. `surveys/responses/` is git-ignored and
   the privacy check flags it if it is ever staged.
4. Claude replies with a goals summary and **Survey 2, skills**, tailored to those goals.
5. Fill in and upload Survey 2 the same way. Claude replies with an evaluation: each skill
   rated against the rubric below, its relevance to your goals, the gap, and a suggested path.
6. Publish the new survey template if you like; update `assets/expertise.yaml` with a new
   `history` line for any level that changed. Repeat the cycle after a few months.

One-time setup for the private folder:

    grep -qxF 'surveys/responses/' .gitignore 2>/dev/null || echo 'surveys/responses/' >> .gitignore

## How the evaluation works

Ratings come from **evidence you describe**, not from self-ratings alone. Claude cannot verify
claims, so the evaluation is only as good as the examples given, and a practical exercise
may be suggested where a claim is unclear.

| Level | Observable behavior |
|---|---|
| novice | Follows a tutorial or existing example; can make small changes with reference material; needs outside help for syntax, design, or debugging |
| working | Builds small tools independently; debugs using documentation and error messages; results are reliable for your own use |
| advanced | Designs multi-part solutions; handles errors and edge cases; others could rely on and maintain the result |
| expert | Designs for scale and failure; reviews and teaches others; knows the tradeoffs and the limits of the tools |

Relevance to a goal: 0 none, 1 supporting, 2 important, 3 critical. **Gap** is the level a goal
needs minus the current level, weighted by relevance. The biggest weighted gaps come first.

## Keep out of the answers

Names of other people (use roles), addresses, employer or client names, account details,
credentials, and anything you would not want attached to a public identity. The files you
upload are not published, but they are still conversation content.
