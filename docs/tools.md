Tools
-----

The Git Info application has a plugin interface for statistics report generating tools.
To implement the interface for a new tool, place a bash file in the `docker/gitinfo/tools`
directory named `<tool>.sh`. Use the following template:

```sh
#!/usr/bin/env bash

# $1 - Repository path
# $2 - Output dir
function run-<tool>() {
    local repo_path=$1
    local output_dir=$2

    <full path to tool> \
        --<arguments>
        "${repo_path}"  \
        > "${output_dir}/index.html" \
        2> "${output_dir}/out.txt"
}
```

As seen from the template, the script should:

1. Have a function named `run-<tool>`, where `<tool>` is the name of the tool,
   all lowercase, single word.
2. The git repository filesystem path is passed as argument `$1` (`${repo_path}`).
3. The output should be written to the output directory passed as
   `$2` (`${output_dir}`), and must produce an `index.html` file.
4. The console output from the execution of the tool should be stored in
   `out.txt` in the `${output_dir}` directory.
5. The output directory is guaranteed to exist.
6. The tool should not be destructive or have side effects that interfere with
   the git repository.

The tool must exist in the image's filesystem.
Hence modify the `Dockerfile` to add installation of the tool in question.
