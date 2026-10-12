# The Arcade Arcade: team preview (retired)

The Arcade Arcade is live at https://www.arcade.dev/arcade/ (ArcadeAI/www PR #634).
Every page here now redirects to its arcade.dev twin.

`build.sh` is still the tool that builds the arcade.dev copy from the game sources next to this repo:

    KEEP_ANALYTICS=1 ./build.sh /api/arcade-leaderboard ~/Desktop/<www checkout>/public/arcade

Then open a PR on ArcadeAI/www. Don't edit `public/arcade/` by hand; edit the source and rebuild.
