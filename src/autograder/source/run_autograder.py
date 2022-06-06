"""
Purdue CS Bridge Gradescope Autograder
>> run_autograder.py

Description:
  This script runs when a student
  uploads their code to Gradescope.

Last updated:
  06/05/2022
"""
from pathlib import Path
import json
import sys
from typing import Dict, List, Union, Literal, Optional
from subprocess import run


autograder = Path("/autograder/source/autograder.jar")
compiled_submission = Path("/autograder/compiled_submission/")
kotlin_root = Path("/usr/lib/kotlin/lib/")
results_file = Path("/autograder/results/results.json")
submission = Path("/autograder/submission/")


def _javac(source_files: List[Path]) -> Optional[str]:
    """Compiles the Java source files and returns any errors."""
    if not source_files:
        return None
    src = [str(x) for x in source_files]
    args = ["javac", "-encoding", "UTF-8", "-d", str(compiled_submission)]
    result = run([*args, *src], capture_output=True, check=False)
    return result.stderr.decode() if result.returncode != 0 else None


def _kotlinc(source_files: List[Path]) -> Optional[str]:
    """Compiles the Kotlin source files and returns any errors."""
    if not source_files:
        return None
    src = [str(x) for x in source_files]
    args = ["kotlinc", "-d", str(compiled_submission)]
    result = run([*args, *src], capture_output=True, check=False)
    return result.stderr.decode() if result.returncode != 0 else None


def get_kotlin_libraries() -> str:
    """Returns the needed Kotlin libraries as a string to add to the JVM classpath."""
    libraries = [Path("kotlin-stdlib.jar"), Path("kotlin-reflect.jar")]
    paths = [str(kotlin_root / jar) for jar in libraries]
    return ":".join(paths)


def find_source_files() -> Dict[Union[Literal["java"], Literal["kotlin"]], List[Path]]:
    """Finds the Java and Kotlin submission files in the submission directory."""
    java_files = [f for f in submission.rglob("*.java") if f.is_file()]
    kt_files = [f for f in submission.rglob("*.kt") if f.is_file()]
    return {"java": java_files, "kotlin": kt_files}


def compile_files(
    source: Dict[Union[Literal["java"], Literal["kotlin"]], List[Path]]
) -> None:
    """
    Compiles the Java and Kotlin files and handles any compiler errors.
    Returns None on success, or exits with (1) on failure.
    """
    error = None
    if not source["java"] and not source["kotlin"]:
        error = "No Java or Kotlin files were submitted."
    else:
        javac_errors = _javac(source["java"])
        kotlinc_errors = _kotlinc(source["kotlin"])
        compiler_errors = ""
        if javac_errors is not None:
            compiler_errors += javac_errors
        if kotlinc_errors is not None:
            compiler_errors += kotlinc_errors
        if compiler_errors:
            error = compiler_errors
    if error is not None:
        err_result = {
            "output": "Unable to compile submission",
            "tests": [
                {
                    "output": error,
                    "score": 0,
                    "number": "",
                    "visibility": "visible",
                    "max_score": 0,
                    "name": "Compiler Output",
                }
            ],
        }
        results_file.write_text(json.dumps(err_result), encoding="utf-8")
        sys.exit(1)


def run_autograder():
    """Runs the autograder with the student submission.
    Note: autograder comes before compiled_submission to guard against class injection.
    The autograder JAR should not contain compiled starter code
    (otherwise the starter code will take precedence over the submission).
    """
    kotlin_libraries = get_kotlin_libraries()
    result = run(
        [
            "java",
            "-cp",
            f"{kotlin_libraries}:{autograder}:{compiled_submission}",
            "TestRunner",
        ],
        check=False,
        capture_output=True,
    )
    if result.stderr:
        sys.stderr.write(result.stderr.decode())
        sys.exit(1)
    results_file.write_bytes(result.stdout)


def main():
    """Grader entry point."""
    files = find_source_files()
    compile_files(files)
    run_autograder()


if __name__ == "__main__":
    main()
