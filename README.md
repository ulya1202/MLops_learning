# 🌐 Dil Seçimi

<details>
<summary>🇦🇿 Azərbaycan</summary>

# 🚀 MLOps-Learning Project

> ⚠️ **Qeyd:** Bu layihə öyrənmək məqsədli yazılıb. Kod və flow **real production üçün tam hazır olmaya bilər**.  
> Məqsəd: workflow, CI/CD, Docker, GitHub Actions, AWS ECR öyrənmək.

---

## 🌟 Layihənin Məqsədi

Bu layihədə məqsədimiz:

1. 🔹 **add_function.py** funksiyasını test etmək.  
2. 🔹 CI/CD pipeline qurmaq və testləri avtomatik run etmək.  
3. 🔹 Docker konteynerləri yaratmaq və AWS ECR-ə push etmək.  
4. 🔹 Branch və Python versiyasına görə image tag-ləri avtomatik yaratmaq.

> 💡 **Niyə belə:** Bu, praktik öyrənmək üçün hazırlanmış flow-dur. Real production-da bəziləri sadələşdirilə bilər.

---

## 🛠 Layihə Flow və Addım-addım

### 1️⃣ Makefile – Workflow-un Əsas İdarəçisi

Makefile həm lokal development, həm CI/CD, həm də cross-platform üçün qurulub.  

<details>
<summary>🧩 Makefile Hədəfləri</summary>

- **setup** – Virtual environment yoxlanır və yaradılır.  
- **install** – Dependencies (`requirements.txt`) quraşdırılır.  
- **format** – Kod `black` ilə formatlanır.  
- **lint** – Kod keyfiyyəti `pylint` ilə yoxlanır.  
- **test** – Unit test + coverage + JUnit XML report (CI-ready).  
- **clean** – Cache və virtual env təmizlənir.  
- **all** – Yuxarıdakı mərhələlərin hamısını run edir.  

> ⚠️ **Niyə conditional logic var:**  
> - UV optionaldır → development rahatlığı, production üçün lazım deyil.  
> - Cross-platform (`Windows/Linux`) support.  
> - Production-da sadəcə venv + pip kifayətdir.

</details>

<details>
<summary>💻 Makefile Məqamları</summary>

- **SYSTEM_PYTHON:** Sistemdə mövcud Python-u tapır.  
  - ✅ Öyrəniləsi: `command -v` və shell substitution.  
  - ⚠️ Məhdudiyyət: Əgər heç bir Python yoxdursa → error.  
- **UV optional logic:**  
  - ✅ Positiv: Dev zamanı sürətli workflow, hot-reload imkanı.  
  - ❌ Negativ: Production üçün artıq, dependency artırır.  
- **Cross-platform binaries:**  
  - ✅ Windows/Linux fərqlərini həll edir.  
  - ⚠️ Production-da adətən Linux əsas götürülür, sadələşdirilir.  

</details>

---

### 2️⃣ GitHub Actions (CI)

- **Matrix Python versiyaları:** 3.9, 3.11, 3.12  
- **Steps:** Checkout → Python setup → UV install → Dependencies → Format → Lint → Test  
- **Niyə belə:** Branch `main` üçün avtomatik test, CI-ready reports.  
- **Positiv:** Automatik test, cross-version, səhvləri əvvəlcədən tutur.  
- **Negativ:** Dev branch-lar üçün əlavə resurs, yavaş build.  

<details>
<summary>💡 learned</summary>

- GitHub Actions matrix ilə version test.   
- Lokal və cloud workflow-un birləşdirilməsi.

</details>

---

### 3️⃣ AWS CodeBuild

- **Install Phase:** Python, pyenv, uv, Makefile commands. Docker daemon start edilir.  
- **Pre-build:** ECR login, IMAGE_TAG yaratmaq (branch + git hash + python version).  
- **Build:** Format → Lint → Test → Docker build & tag.  
- **Post-build:** Docker push → main branch üçün ayrıca `latest` tag.  
- **Reports:** Pytest JUnit XML report.
<details>
<summary> 🔹 Install Phase</summary>

- Python versiyasını seçir və qurur  
- Virtual environment və dependencies quraşdırır  
- Optional: UV ilə lokal environment idarəsi (dev üçün)  
- Docker daemon-u hazır vəziyyətə gətirir  

**✅ Pozitiv:** Flexible, cross-version testing, lokal və cloud mühitdə işləyir  
**❌ Negativ:** UV conditional logic prod-da lazım olmaya bilər, Docker-daemon açıq start təhlükə yarada bilər  

</details>

<details>
<summary>🔹 Pre-build Phase</summary>

- AWS ECR-ə login  
- Branch adını və git hash-i oxuyur → unik image tag  
- Branch-aware versioning  

**✅ Pozitiv:** Unik image, rollback imkanı, branch-aware automation  
**❌ Negativ:** Branch parsing səhv olarsa, image tag səhv ola bilər, naming convention prod-da vacibdir  

</details>

<details>
<summary> 🔹 Build Phase</summary>

- Kod formatlanır və lint yoxlanır  
- Testlər run olunur, coverage çıxarılır  
- Docker image build və lokal tag əlavə edilir  

**✅ Pozitiv:** Tam CI pipeline (test + Docker image)  
**❌ Negativ:** Multi-stage Docker build prod üçün daha optimal olardı, test failures build-i dayandıra bilər  

</details>

<details>
<summary>🔹 Post-build Phase</summary>

- Main branch-dədirsə → `latest` tag əlavə edilir və AWS ECR-ə push edilir  

**✅ Pozitiv:** Production branch üçün avtomatik latest image  
**❌ Negativ:** Branch detection səhv olarsa yanlış image push, IAM permissions və security məsələlərinə diqqət lazımdır  

</details>

<details>
<summary> 3️⃣ AWS Permissions və Setup</summary>

- CodeBuild IAM rolunda **ECR push** hüququ olmalıdır  
- Docker build üçün **privileged mode** lazım ola bilər  
- Sensitive credentials hard-coded olmamalıdır  

**Öyrəniləcək:** Permissions, access control, cloud security, safe Docker practices  

</details>


> ⚠️ **Positiv:** Cloud build + container registry inteqrasiyası, branch-aware tagging.  
> ❌ **Negativ:** Permissions, AWS mühitində Docker daemon start + ECR auth lazımdır.

<details>
<summary>💡 learned</summary>

- Docker + AWS ECR workflow.  
- Branch, git hash, Python versiyasına görə image tag.  
- CI/CD + Cloud automation.  
- Production-da permissions və security qaydalarına diqqət:  
  - ECR push üçün IAM user lazım.  
  - Elastic Container Service və ya Fargate üçün run permissions.  
  - Docker run mühiti üçün access rights düzgün təyin edilməlidir.

</details>

---

### 4️⃣ Dockerfile 

- **Purpose:** Production üçün minimal və clean container.  
- Makefile və UV conditional logic yoxdur. Sade və optimized build.  
- Docker image AWS ECR-ə push üçün hazır vəziyyətdədir.  

> ⚠️ **Learn:** Production üçün Dockerfile yazarkən minimalism və security önəmlidir.  
> ✅ Pozitiv: Faster build, less complexity, secure.  
> ❌ Negativ: Dev testing workflow yox, test və lint container içində run edilməyəcək.

<details>
<summary>💡 learned</summary>
- Production Dockerfile → clean, UV və dev conditional logic olmadan.  
- IMAGE_TAG branch, Python versiyası və git hash-ə görə hələ də təyin olunur.  
- AWS ECR setup və permissions düzgün qurulmalıdır.
</details>
---

### ✅ Nəticə</summary>

- **Makefile**-in conditional logic, cross-platform və optional UV hissələri öyrənildi.  
- **GitHub Actions** ilə CI, **AWS CodeBuild** ilə cloud build, və **Docker** ilə konteynerization workflow başa düşüldü.  
- **Branch**, **Python version** və **git hash** əsasında avtomatik **IMAGE_TAG** yaratmaq öyrənildi.  
- Production üçün Dockerfile sade və minimal, conditional logic olmadan quruldu.  
- AWS ECR push və Docker run üçün **permissions və security setup** vacibdir.  

> 💡 bu layihə tam olaraq CI/CD deyil, amma CI/CD-nin əsas komponentlərini praktik şəkildə öyrənmək üçün mini-laboratoriya rolunu oynayır.


</details>
<details>
<summary> English </summary>
---
  
## 🌟MLOps-Learning Project
 

> ⚠️ **Note:** This project is written for learning purposes. The code and workflow **may not be fully production-ready**.  
> Goal: Learn workflow, CI/CD, Docker, GitHub Actions, and AWS ECR.

---

## 🌟 Project Goals

In this project, we aim to:

1. 🔹 Test the **add_function.py** function.  
2. 🔹 Build a CI/CD pipeline and automatically run tests.  
3. 🔹 Create Docker containers and push them to AWS ECR.  
4. 🔹 Automatically generate image tags based on branch and Python version.

> 💡 **Why like this:** This workflow is designed for practical learning. Some steps could be simplified in real production.

---

## 🛠 Project Flow & Step-by-Step

### 1️⃣ Makefile – Main Workflow Manager

Makefile is designed for both local development and CI/CD, supporting cross-platform usage.

<details>
<summary>🧩 Makefile Targets</summary>

- **setup** – Checks and creates a virtual environment.  
- **install** – Installs dependencies from `requirements.txt`.  
- **format** – Formats code using `black`.  
- **lint** – Checks code quality using `pylint`.  
- **test** – Runs unit tests + coverage + JUnit XML report (CI-ready).  
- **clean** – Cleans cache and virtual environment.  
- **all** – Executes all the above steps sequentially.

> ⚠️ **Why conditional logic exists:**  
> - UV is optional → convenient for development, not needed in production.  
> - Cross-platform support (Windows/Linux).  
> - In production, usually venv + pip is enough.

</details>

<details>
<summary>💻 Makefile Learning Points</summary>

- **SYSTEM_PYTHON:** Detects existing Python on the system.  
  - ✅ Learn: `command -v` and shell substitution.  
  - ⚠️ Limitation: If no Python exists → error.  
- **UV optional logic:**  
  - ✅ Positive: Fast workflow, hot-reload in dev.  
  - ❌ Negative: Extra dependency for production.  
- **Cross-platform binaries:**  
  - ✅ Handles Windows/Linux differences.  
  - ⚠️ In production, usually Linux-only, simplified.

</details>

---

### 2️⃣ GitHub Actions (CI)

- **Matrix Python versions:** 3.9, 3.11, 3.12  
- **Steps:** Checkout → Python setup → UV install → Dependencies → Format → Lint → Test  
- **Why:** Automatically run tests for `main` branch with CI-ready reports.  
- **Positive:** Automatic test, cross-version, catches errors early.  
- **Negative:** Extra resources for dev branches, slower builds.

<details>
<summary>💡 Lessons Learned</summary>

- GitHub Actions matrix testing.  
- Combining local and cloud workflows.

</details>

---

### 3️⃣ AWS CodeBuild

- **Install Phase:** Selects Python version, sets up pyenv, optional UV, runs Makefile commands. Starts Docker daemon.  
- **Pre-build:** Logs in to ECR, creates IMAGE_TAG (branch + git hash + Python version).  
- **Build:** Format → Lint → Test → Docker build & tag.  
- **Post-build:** Push to Docker → add `latest` tag for main branch.  
- **Reports:** Pytest JUnit XML report.

<details>
<summary>🔹 Install Phase</summary>

- Selects Python version and installs it  
- Sets up virtual environment and dependencies  
- Optional: UV for local dev environment  
- Prepares Docker daemon  

**✅ Positive:** Flexible, cross-version testing, works in local & cloud  
**❌ Negative:** UV conditional logic not needed in prod, Docker daemon open start can be risky  

</details>

<details>
<summary>🔹 Pre-build Phase</summary>

- Logs in to AWS ECR  
- Reads branch name and git hash → unique image tag  
- Branch-aware versioning  

**✅ Positive:** Unique image, rollback possible, branch-aware automation  
**❌ Negative:** If branch parsing fails, image tag can be wrong; strict naming needed in production  

</details>

<details>
<summary>🔹 Build Phase</summary>

- Formats code, runs lint  
- Runs tests and generates coverage  
- Builds Docker image and adds local tag  

**✅ Positive:** Complete CI pipeline (tests + Docker image)  
**❌ Negative:** Multi-stage Docker build would be more optimal for prod; test failures can halt build  

</details>

<details>
<summary>🔹 Post-build Phase</summary>

- If on main branch → adds `latest` tag and pushes to AWS ECR  

**✅ Positive:** Automatic latest image for production branch  
**❌ Negative:** Wrong branch detection → wrong image push; IAM permissions and security must be handled  

</details>

<details>
<summary>3️⃣ AWS Permissions & Setup</summary>

- CodeBuild IAM role must have **ECR push** permissions  
- Docker build may require **privileged mode**  
- Sensitive credentials should **never be hard-coded**  

**Learning:** Permissions, access control, cloud security, safe Docker practices  

</details>

---

### 4️⃣ Dockerfile

- **Purpose:** Production-ready minimal and clean container  
- No Makefile or UV conditional logic → simpler, optimized build  
- Ready for AWS ECR push  

> ⚠️ **Learn:** Production Dockerfile → minimal and secure  
> ✅ Positive: Faster build, less complexity, secure  
> ❌ Negative: Dev workflow (test/lint) not run inside container  

<details>
<summary>💡 Lessons Learned</summary>

- Production Dockerfile → clean, no UV/dev logic  
- IMAGE_TAG still set via branch, Python version, git hash  
- AWS ECR setup & permissions must be correct  

</details>

---

### ✅ Conclusion

- Learned Makefile conditional logic, cross-platform, optional UV workflow.  
- Understood CI via GitHub Actions, cloud build via AWS CodeBuild, Docker containerization.  
- Learned to generate IMAGE_TAG automatically (branch, Python version, git hash).  
- Production Dockerfile is minimal, conditional logic removed.  
- AWS ECR push and Docker run require correct **permissions & security setup**.  

> 💡 **Truth:** This project is **not full CI/CD**, but acts as a mini-lab to practice key CI/CD components.

