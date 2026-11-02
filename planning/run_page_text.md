# Text for the top of the /run/ page (draft, for Allen to revise)

Task 3 moves `site/landing.html` to `/run/`, the page that lists the chapter notebooks on JupyterLite. This text goes near its top. It replaces the current note: "Your changes are saved in this browser only. To work with all the files, including each chapter's code, open the full workspace."

---

## Two ways to work

- **One chapter at a time** (the chapter links below): the notebook fills the window, like a page of the book. This is the simplest way to start.
- **The full workspace**: a file browser and tabs, like a desktop programming environment. Use it to open several chapters side by side, or to look at and edit a chapter's `.m` files.

Both views see the same files and the same changes.

## Saving your work

- Your changes are stored inside your web browser, on this computer. They are not uploaded anywhere, and you don't need an account.
- When you come back in the same browser on the same computer, your changes are still there.
- Another computer, another browser, or a private window won't have them. Clearing your browser's history and site data deletes them.
- To keep a copy, use **File → Download**. You can bring the copy back later with the upload button in the full workspace.
- Once you've changed a chapter, you keep seeing your version, even if we update the book. To get the current version back, delete your copy in the full workspace.

---

Checked on the live site (2026-11-02, Chromium):
- Saved edits survive a reload.
- Both views show the same edits.
- Another browser profile doesn't see them.
- File → Download is in the menu.

Not tested; this is JupyterLite's documented behaviour:
- private windows;
- clearing site data;
- an edited copy hiding later site updates.
