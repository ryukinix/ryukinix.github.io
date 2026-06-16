# Manoel V. Machado's Blog & Personal Website

This repository contains the source code, assets, and blog posts for my personal website and blog, hosted at [lerax.me](https://lerax.me). The blog is built using **Jekyll**, styled with custom **Sass**, and features a specialized publishing pipeline supporting **Org-mode** (via Emacs and `org2jekyll`). It can be developed and run both locally via Ruby or inside isolated **Docker** containers.

---

## 📂 Project Structure

Below is an overview of the repository's layout and how the different directories and files contribute to the blog:

```text
.
├── _config.yml               # Global Jekyll configuration (title, plugins, social media, etc.)
├── Gemfile / Gemfile.lock    # Ruby dependencies
├── Dockerfile                # Debian-based Docker image definition with Jekyll & dependencies
├── Makefile                  # Build and deployment commands
├── _data/                    # Custom data files
│   └── navigation.yml        # Navigation menu structure
├── _includes/                # Reusable HTML partials/components (header, footer, comments, etc.)
├── _layouts/                 # Jekyll page templates (home, post, page, categories, project)
├── _posts/                   # Published posts (compiled HTML or markdown format, YYYY-MM-DD-title.*)
├── _sass/                    # Custom SCSS stylesheets (typography, variables, responsive design)
├── assets/                   # Static assets of the website
│   ├── css/                  # Compiled stylesheet entries
│   ├── img/                  # Images, avatars, post illustrations, and backgrounds
│   └── js/                   # Custom and vendor JS scripts (interactivity, popups, scrolling)
└── org/                      # Raw Org-mode source files of the blog posts
    ├── .dir-locals.el        # Local Emacs configuration for org2jekyll automatic mode activation
    └── [categories]/         # Subdirectories containing .org files
```

---

## 🛠️ Development & Build Commands

A `Makefile` is provided to streamline common development, build, and deployment operations.

### Docker-based Development (Recommended)

Running the blog inside Docker avoids having to manage local Ruby and Gem installations. The container handles all Jekyll dependencies.

*   **Build the Docker Image:**
    ```bash
    make build
    ```
    This builds the Docker image tagged as `ryukinix/blog` using the `Dockerfile`.
*   **Run the Development Server:**
    ```bash
    make run
    ```
    *(Equivalent to running `make` with no arguments)*  
    Builds the image if not already built, and runs a container on `http://localhost:4000`. 
    It mounts critical directories (`_posts`, `assets`, `_sass`, `_includes`, `_layouts`, `about`) as volumes, enabling **live-reload** so changes are updated instantly in your browser as you save files.
*   **Debug/Test Build Output:**
    ```bash
    make build-show
    ```
    Runs a one-off build inside the Docker container to display trace output and check for errors.

### Local/Native Ruby Development

If you prefer to run Jekyll natively on your host machine:

*   **Install Dependencies Locally:**
    ```bash
    make install-local
    ```
    Installs all necessary Ruby gems locally under the `vendor/bundle` directory.
*   **Run Local Jekyll Server:**
    ```bash
    make run-local
    ```
    Launches the local Jekyll server using `bundle exec jekyll serve` on `http://localhost:4000`.
*   **Clean Up Local Build Artifacts:**
    ```bash
    make clean-local
    ```
    Deletes the generated local site directory (`_site/`) and the locally installed gems (`vendor/`).

### Deployment and Distribution

*   **Publish Docker Image:**
    ```bash
    make publish
    ```
    Pushes the compiled `ryukinix/blog` Docker image to Docker Hub.
*   **Test Deploy:**
    ```bash
    make deploy-test
    ```
    Builds and publishes the Docker image, and then connects via SSH to the server `starfox` to trigger `/home/lerax/Deploy/blog.sh` to redeploy the site.

---

## 📝 Writing Posts with Org-Mode

This project uses **Org-mode** as the primary authoring format for blog posts. Original posts are saved in the `org/` directory and compiled into `_posts/` as standard HTML posts.

### How it Works

1.  **Repository Setup**:
    The `org/` directory contains a `.dir-locals.el` file:
    ```elisp
    ((org-mode . ((eval . (org2jekyll-mode)))))
    ```
    This automatically enables `org2jekyll-mode` in Emacs whenever you open any `.org` file under `org/`.
2.  **Writing an Org Post**:
    Org files should start with specific Org headers that `org2jekyll` converts to Jekyll Front Matter. For example:
    ```org
    #+STARTUP: showall
    #+STARTUP: hidestars
    #+OPTIONS: H:2 num:nil tags:t toc:nil timestamps:t
    #+LAYOUT: post
    #+AUTHOR: Manoel Vilela
    #+DATE: 2025-07-20 dom 01:11
    #+TITLE: Common Lisp Brasil
    #+DESCRIPTION: Gerenciando a comunidade de Common Lisp desde 2018
    #+TAGS: programming lisp
    #+CATEGORIES: programming
    #+PROJECT: true

    * O início de tudo
    Este post deve contar parte da história...
    ```

3.  **Compiling and Publishing**:
    Within Emacs, triggering the `org2jekyll` export/publishing functions translates your `.org` file into an HTML file under `_posts/` (e.g., `_posts/2025-07-20-common-lisp-brasil.html`).
    
    The export process automatically generates the Jekyll-compatible YAML front matter from the Org-mode headers:
    ```yaml
    ---
    date: 2025-07-20 01:11
    author: Manoel Vilela
    layout: post
    title: Common Lisp Brasil
    excerpt: Gerenciando a comunidade de Common Lisp desde 2018
    tags: 
    - programming
    - lisp
    categories: 
    - programming
    project: true
    ---
    ```
    Once the post is generated in `_posts/`, Jekyll's build pipeline compiles it into the final static webpage.

---

## 🤖 Continuous Integration (CI)

This repository includes a GitHub Actions CI workflow (defined in `.github/workflows/build.yml`) that validates pull requests to the `master` branch by automatically building the Docker image to ensure the site compiles cleanly without errors.
