# Text for the top of the /run/ page (draft, for Allen to revise)

Task 3 moves `site/landing.html` to `/run/`, the page that lists the chapter notebooks on JupyterLite. This text goes near its top. It replaces the current note: "Your changes are saved in this browser only. To work with all the files, including each chapter's code, open the full workspace."

---

## Two ways to work

- **One chapter at a time** (the chapter links below): the notebook fills the window, like a page of the book. This is the simplest way to start.
- **The full workspace**: a file browser and tabs, like a desktop programming environment. Use it to open several chapters side by side, or to look at and edit a chapter's `.m` files.

Both views see the same files and the same changes.

## Saving your work

- Your changes are stored inside your web browser, on your computer. They are not uploaded anywhere, so you don't need an account.
- When you come back in the same browser on the same computer, your changes are still there.
- Another computer, another browser, or a private window won't have them. Clearing your browser's history and site data deletes them.
- To keep a copy, use **File → Download**, which saves the notebook to your computer, usually in your Downloads folder, under a name like `chap02_chap02.ipynb`. It's an ordinary Jupyter notebook file, which you can keep, email or open in other Jupyter tools. In the full workspace, you can also download a chapter's `.m` files: right-click a file and choose **Download**.
- To bring a copy back later, open the full workspace, open the chapter's folder, and click the upload button (the arrow pointing up, above the file list). Select the file from your computer. The uploaded file should appear in the folder under its own name, next to the chapter's notebook, which is not replaced, and you can open it from there.
- Once you've changed a chapter, you keep seeing your version, even if we update the book. To get the current version back, delete your copy: in the full workspace, right-click the notebook and choose **Delete**. The original version appears in its place. Download your copy first if you want to keep it.

---

Checked on the live site (2026-11-02, Chromium):
- Saved edits survive a reload.
- Both views show the same edits.
- Another browser profile doesn't see them.
- File → Download is in the menu.

Checked on a local build of the new site (2026-11-02, Chromium):
- File → Download in the one-chapter view saves `chap02_chap02.ipynb` (the browser turns the path's `/` into `_`), with the edits.
- Uploading it into `chap02/` in the workspace adds it under that name, with no prompt; `chap02.ipynb` is unchanged.
- Right-clicking a `.m` file offers Download.
- Deleting an edited `chap02.ipynb` (it asks first) brings back the original right away.

Not tested; this is JupyterLite's documented behaviour:
- private windows;
- clearing site data;
- an edited copy hiding later site updates.
