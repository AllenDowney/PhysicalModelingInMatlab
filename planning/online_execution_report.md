# Running the examples online: feasibility report

Task 2. Written 2026-11-01. Brief: [online_execution.md](online_execution.md).

**Verified** means one of three things: we ran it ourselves (local Octave, a real Colab runtime, or headless Chromium), fetched the page or endpoint, or read the platform's source code. **Reported** means the claim comes from documentation or a forum post, or is inferred, and has not been tested. Nothing here has yet been tested by a person in a normal browser; see "Open questions".

## Summary

The best fit is **JupyterLite with the xeus-octave kernel**, published on the book's own GitHub Pages site. It runs Octave 10.3 compiled to WebAssembly, entirely in the reader's browser:

- no account, no server, nothing to maintain beyond the static site
- plots appear inline
- a link can carry an example's code

It ran the book's `lorenz.m` (`ode45`, a local function, `plot3`) in 1.3 s, as Demonstration 1 below shows.

Octave Online, the initial favorite, is weaker than expected:
- Buckets can be opened without an account, but they can only be made by hand, with no API.
- Guests get about 5 s per command.
- The source code has hardly changed since January 2025.

Colab works, but readers need a Google account and every session spends about 70 s installing Octave.

## 1. What each platform can do

### JupyterLite + xeus-octave (in-browser WebAssembly)

- **Verified** (headless Chromium, `https://jupyter-xeus.github.io/xeus-octave/repl/index.html?kernel=xoctave&code=…`):
  - It reports Octave 10.3.0 for `wasm32-unknown-emscripten`.
  - `ode45`, `fzero` and `fminsearch` gave the correct values.
  - `plot` draws inline through a plotly graphics toolkit.
  - The book's `code/chap10/lorenz.m`, written into the browser filesystem, ran with its 3D plot in 1.3 s.
- **Verified:**
  - The `code=` URL parameter pre-fills and runs code.
  - The demo site sends no X-Frame-Options or CSP header, so it can be embedded in an iframe.
  - `octave` 10.3.0 and `xeus-octave` 0.7.0 are on emscripten-forge (updated 2026-03-11).
  - `jupyter-xeus/xeus-octave` is active (v0.6.3 in 2026-01, pushes in 2026-03).
- **Verified gap:** `title(...)` didn't render in the plotly figure. Axis labels did.
- **Reported:** a site of our own can be built from the `jupyterlite/xeus-lite-demo` template, with an `environment.yml` listing `xeus-octave` and `code/` included as files, and deployed to GitHub Pages. The project calls the kernel new.

### Octave Online (octave-online.net)

- **Buckets are read-only snapshots** of a signed-in user's files. Their "main" script runs when the bucket opens.
- **Verified (socket request, no account):** a guest gets the bucket. Example: `bucket~FSya2uEDb9Z6L5DC3JQZLG`, created in 2020 and active in 2026-04, so buckets last.
- **Verified (source):** only signed-in users can create buckets.
- **Reported (source and UI text):** guests can edit and run, but their edits are temporary. Forking needs sign-in.
- **No API (reported, source):** buckets are created through a socket event in a logged-in session, so they can't be published from GitHub. A bucket can't be updated: a new version means a new bucket. Its short link (`octav.onl/…`) can probably be moved to the new bucket by hand.
- **No URL opens a specific file** (reported, source). `#cmd=<code>` runs code at the prompt (reported, source).
- **Embedding (verified):** no X-Frame-Options or CSP header. Whether cookies and the websocket work inside an iframe is untested.
- **Limits (reported, default config):**
  - 5 s per command for guests, 10 s signed in, plus an "Add Seconds / Upgrade" button.
  - Idle sessions end after 15 minutes.
  - Output pauses after 5 KB for guests.
  - Paid tiers through Patreon (verified: the live page shows "Upgrade with Patreon", "US$3/mo").
- **Health (verified, GitHub API):** AGPL. The last commit on `master` was 2024-01; the last push 2025-01; 54 open issues. Self-hosting is documented as not safe for untrusted users.

### Google Colab (Python runtime + Octave)

**Verified on a real Colab runtime** (the `colab-run` skill, 2026-11-01). The setup cell is:

```
!apt-get -qq install -y --no-install-recommends octave gnuplot-nox fonts-freefont-otf
%pip install -q oct2py
%load_ext oct2py.ipython
```

- It installs Octave 8.4 in 42 s, plus 25 s for `oct2py`.
- After that, `%%octave` cells run scripts, `ode45`, `fzero` and `fminsearch`, and can define functions.
- Variables persist between cells, and plots appear inline as SVG.
- Without `fonts-freefont-otf`, `plot` fails with "ft_text_renderer: invalid bounding box", the same as in CI.
- Readers need a Google account to run anything.

### Binder (mybinder.org)

- **Verified:** it builds this repo's `environment.yml`. The first launch took about 4 min. A later launch went to a different member and rebuilt from scratch in about 4 min. An `octave` kernel is listed.
- **Not verified:** whether code actually runs. The kernel websocket closed at once from both test clients. This is probably on Binder's side.
- **Reported:** run by a federation of 2i2c, GESIS and BIDS since OVH's sponsorship ended in 2024.

### SageMathCell (sagecell.sagemath.org)

- **Verified:** it offers Octave 11.1.0, with no account. `ode45`, `fzero` and `fminsearch` work.
- **Verified:** permalinks work (`?z=…&lang=octave`), and `embedded_sagecell.js` lets you put cells in a page.
- **Verified: `plot` fails** because a font is missing on the server. The `/service` REST endpoint returns Cloudflare 520.

### Others

- **MATLAB Online** (verified): it can't be embedded (`frame-ancestors` is limited to mathworks.com). `matlab.mathworks.com/open/github/v1?repo=…` resolves.
  - Reported: needs a free MathWorks account, with 20 h a month.
  - It's the real MATLAB, but registration is required.
- **CoCalc** (verified): now cocalc.ai, an AI-focused product. The GitHub viewer returns 410, there's no anonymous sign-up, and network access is a paid feature. Not suitable.
- **tio.run** (verified): Octave 4.2.2 (2018), text only.
- **OneCompiler, JDoodle, ideone** (reported): text only.
- **Replit**: no Octave template.
- **Kaggle**: no Octave.

## 2. Comparison

| | No install | No account | Edit and rerun | Plots | Links from Pages | Embed | Maintenance for Allen |
|---|---|---|---|---|---|---|---|
| **JupyterLite + xeus-octave** | yes | **yes** | yes | yes (no titles) | code in URL, or files on our site | yes | rebuild the static site; young project upstream |
| Octave Online | yes | **yes** (view and run) | yes (temporary) | yes (reported) | bucket links | headers allow | buckets by hand, new ID per update; 5 s limit |
| Colab | yes | no (Google) | yes | yes | notebooks from GitHub | no | notebooks plus a setup cell; ~70 s per session |
| Binder | yes | yes | not confirmed | not confirmed | one URL per repo | possible | none; 4+ min launches |
| SageMathCell | yes | yes | yes | **broken** | `?z=` permalinks | yes | none, but no plots |
| MATLAB Online | yes | no | yes | yes | open-from-GitHub URL | no | none; real MATLAB |

For a whole class, only the in-browser option scales at no cost, because each reader's computer does the work. Octave Online guests share its free servers and its time limits. Colab and MATLAB Online are free for each reader but need accounts.

## 3. Recommended architecture

1. **A JupyterLite site on GitHub Pages**, built from `jupyterlite/xeus-lite-demo`. It has an `environment.yml` with `xeus-octave`, and `code/` (all chapters) is copied in as its files. A GitHub Actions workflow builds and deploys it on each push to `master`. Nothing runs on a server.
2. **"Run this example" links** in the chapter pages, of two kinds:
   - A file: the link opens the site with the chapter folder. Readers open the `.m` file, edit it and run it; their edits are saved in browser storage.
   - A short snippet: a `repl/?kernel=xoctave&code=…` link built from the listing.
3. **Chapter pages:** keep the PDF as the book. If chapters move to Quarto, put the links in the listings with a shortcode. The book still prints the same code because the listings and the site both come from `code/`. This is the single-source question in the brief: worth doing, but it isn't needed for step 1.
4. **Fallbacks:** mention Octave Online (no account) and MATLAB Online (real MATLAB) in the README for readers whose browsers struggle with a ~100 MB WebAssembly download.

## 4. Demonstration

These run on the xeus-octave project's own demo site; nothing of ours is deployed yet.

- **Chapter 9's rat model** (the model in `code/chap09/rat_pop.m`, inlined as an anonymous function; ends at 2075 rats, checked in local Octave): [open in xeus-octave](https://jupyter-xeus.github.io/xeus-octave/repl/index.html?kernel=xoctave&code=%25%20Chapter%209%3A%20the%20rat%20population%20model%20from%20rat_pop.m%0Aa%20%3D%200.002%3B%0Aomega%20%3D%202%2Api%20%2F%20365%3B%0Arate_func%20%3D%20%40%28t%2C%20y%29%20a%20%2A%20y%20%2A%20%281%20-%20cos%28omega%20%2A%20t%29%29%3B%0A%5BT%2C%20Y%5D%20%3D%20ode45%28rate_func%2C%20%5B0%2C%20365%5D%2C%201000%29%3B%0Aplot%28T%2C%20Y%29%0Axlabel%28%27Time%20%28days%29%27%29%0Aylabel%28%27Population%20%28rats%29%27%29%0AY%28end%29)
- **Chapter 2's `fibonacci1.m` with `n = 10`** (expect `ans = 55.000`) on Octave Online, through `#cmd=`: [open in Octave Online](https://octave-online.net/#cmd=n%20%3D%2010%3B%20s5%20%3D%20sqrt%285%29%3B%20t1%20%3D%20%281%20%2B%20s5%29%20%2F%202%3B%20t2%20%3D%20%281%20-%20s5%29%20%2F%202%3B%20diff%20%3D%20t1%5En%20-%20t2%5En%3B%20ans%20%3D%20diff%20%2F%20s5)

## 5. Keeping the examples in sync with the repo

- The site's files are `code/` at build time, so a push to `master` updates it. The CI tests already run that code in Octave 8.4.
- Add one more test job: run a few chapters in the xeus-octave kernel with headless Chromium. That catches WebAssembly-specific breakage, such as missing functions.
- Snippet links can be generated from the listings by a script, so they can't drift by hand.
- Pin the `xeus-octave` version in the site's `environment.yml`, and update it on purpose.

## 6. Open questions and the smallest experiments

These need a person in a real browser:

1. **xeus-octave on the demo site:** open `https://jupyter-xeus.github.io/xeus-octave/lab/` in a private window on a laptop, on Safari and on a phone.
   - How long does the first load take?
   - Paste `code/chap12/baseball2.m`. Do `legend`, `hold on`, `subplot` and `title` work?
   - Do edits survive a reload?
2. **Octave Online as a guest:** open the demo link above. Then run the ODE in `code/chap12/baseball2.m`. Does it finish within the guest time limit, or does the "Add Seconds" countdown appear?
3. **Binder:** open `https://mybinder.org/v2/gh/AllenDowney/PhysicalModelingInMatlab/master` and start an Octave notebook. Does the kernel connect, and does a plot appear?
4. **Building our own site:** fork `jupyterlite/xeus-lite-demo` into a test repo with `xeus-octave` and `code/chap02`, `chap09` and `chap12`. Check the build time, the site size, and that the files open and run. This is the smallest real step toward the recommended architecture, and it's the next one.
