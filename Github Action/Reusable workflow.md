
# Reusable workflow

- From automating repetitive tasks to building CI/CD pipelines, had to copy and paste YAML files from one repository to another if you wanted to use them in more than one place.
- For that Enter reusable workflows, which is a simple and powerful way to avoid copying and pasting workflows across your repositories.
- Create a reusable workflow in a file located at .github/workflows/reusable-date-workflow.yml

```
name: Reusable Date Workflow
on:
  workflow_call:
    inputs:
      runTests:
        required: true
        type: boolean
      deployEnv:
        required: true
        type: string
      currentDate:
        required: true
        type: string

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      
      - name: Display Current Date
        run: echo "Current date is: ${{ inputs.currentDate }}"

  test:
    runs-on: ubuntu-latest
    needs: build
    if: ${{ inputs.runTests == 'true' }}
    steps:
      - name: Run Tests
        run: echo "Running tests on ${{ inputs.currentDate }}..."

  deploy:
    runs-on: ubuntu-latest
    needs: test
    if: ${{ inputs.deployEnv == 'production' }}
    steps:
      - name: Deploy to Production
        run: echo "Deploying to production environment on ${{ inputs.currentDate }}..."
```
### Calling the Reusable Workflow
Next, create a caller workflow that invokes the reusable workflow. This file can also be located in the .github/workflows directory, for example, .github/workflows/caller-workflow.yml
```
name: Caller Workflow
on:
  push:
    branches:
      - main

jobs:
  call-reusable-workflow:
    uses: .github/workflows/reusable-date-workflow.yml   #specify the reuseableworkflow link.
    with:
      runTests: true          # Specify whether to run tests or not
      deployEnv: 'production' # Specify the deployment environment
      currentDate: ${{ github.event.head_commit.timestamp }} # Pass current date from commit timestamp
```
### Explanation of Key Components

```
on:
  workflow_call:
    inputs:
      runTests:
        required: true
        type: boolean
      deployEnv:
        required: true
        type: string
      currentDate:
        required: true
        type: string
```

- Purpose: This section specifies that the workflow can be triggered by another workflow using workflow_call. It also defines three required inputs:
  - runTests: A boolean input to determine if tests should be run.
  - deployEnv: A string input to specify the deployment environment (e.g., production or staging).
  - currentDate: A string input to pass the current date, which will be displayed during the workflow execution.

#### Jobs Section
```
jobs:
  build:
    runs-on: ubuntu-latest
```
- Purpose: This defines a job named build, which will run on the latest version of Ubuntu. Each job runs in its own virtual environment.

#### Steps in the Build Job
```
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
```
- Purpose: This step uses the actions/checkout action to clone the repository's code into the runner environment. This is necessary for subsequent steps that need access to the repository files.

```      
- name: Display Current Date
  run: echo "Current date is: ${{ inputs.currentDate }}"
```
- Purpose: This step runs a shell command that outputs the current date passed as an input to the workflow. The ${{ inputs.currentDate }} syntax accesses the input value, allowing you to display it dynamically.

```
  test:
    runs-on: ubuntu-latest
    needs: build
    if: ${{ inputs.runTests == 'true' }}
```
- Purpose: This defines a second job named test, which also runs on Ubuntu.
  - needs: build: Indicates that this job depends on the successful completion of the build job.
  - if: ${{ inputs.runTests == 'true' }}: This condition checks if runTests is set to true. If it is not, this job will be skipped.

### Steps in the Test Job
```
    steps:
      - name: Run Tests
        run: echo "Running tests on ${{ inputs.currentDate }}..."
```
- Purpose: This step runs a command that simulates running tests and outputs a message indicating that tests are being executed on the specified date. Again, it uses ${{ inputs.currentDate }} to reference the date input.

```
  deploy:
    runs-on: ubuntu-latest
    needs: test
    if: ${{ inputs.deployEnv == 'production' }}
```
- Purpose: This defines a third job named deploy, which also runs on Ubuntu.
  - needs: test: Indicates that this job depends on the successful completion of the test job.
  - if: ${{ inputs.deployEnv == 'production' }}: Checks if deployEnv is set to production. If it is not, this job will be skipped.

### Steps in the Deploy Job

```
    steps:
      - name: Deploy to Production
        run: echo "Deploying to production environment on ${{ inputs.currentDate }}..."
```
- Purpose: This step simulates a deployment process by outputting a message indicating that deployment is happening in the production environment, using ${{ inputs.currentDate }} for context.

### Caller Workflow Definition
File: .github/workflows/caller-workflow.yml

```
on:
  push:
    branches:
      - main
```
- Purpose: Specifies that this workflow should trigger on pushes to the main branch. Whenever code is pushed to this branch, this workflow will execute.

#### Jobs Section
```
jobs:
  call-reusable-workflow:
    uses: .github/workflows/reusable-date-workflow.yml@main
```
- Purpose: Defines a job named call-reusable-workflow, which calls the reusable workflow defined earlier.
   - The @main indicates that it should use the version of this reusable workflow from the main branch.

### Input Parameters for Reusable Workflow
```
    with:
      runTests: true          # Specify whether to run tests or not
      deployEnv: 'production' # Specify the deployment environment
      currentDate: ${{ github.event.head_commit.timestamp }} # Pass current date from commit timestamp
```
- Purpose:
  - runTests: true – Indicates that tests should be executed.
  - deployEnv: 'production' – Specifies that deployment should occur in a production environment.
  - currentDate: ${{ github.event.head_commit.timestamp }} – Passes the timestamp of the latest commit as the current date. This uses GitHub's context variables to dynamically retrieve information about the event triggering this workflow.
