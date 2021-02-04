# CS Bridge Java Autograder for Gradescope

This repository contains our autograder script and the necessary files to build the autograder Docker image. This image serves as a template for assignment autograders to be built from.

## Usage
To use this image, add the following line to the top of your `Dockerfile`.
```docker
FROM purduecsbridge/java-autograder:latest
```

When using this image, make sure to build a JAR and place it at `/autograder/source/autograder.jar`. For an example of this, see our [lab template](https://github.com/purduecsbridge/lab-template).

The JAR must contain a main class named `TestRunner` in the default package. To use a different class, you can override the `run_autograder` for each assignment by copying the modified script in your `Dockerfile` or by forking this repo and changing the main script itself.

## Contributing
Because this repository builds the autograder we use in production, we will be very cautious when accepting pull requests. If you would like to make changes to make the autograder work better for you, we suggest forking this repo.

However, if there are changes that can be useful for anyone, we welcome your suggestions.

## License
Licensed under the [MIT License](LICENSE).
