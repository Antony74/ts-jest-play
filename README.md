# ts-jest-play

Written to figure out how many "edits" are required to set up a new project with TypeScript and Jest.  Around ten.

They're captured as shell commands in the Dockerfile for reproducibility.

Command to build it:

    docker build -t akb74/ts-jest-play .

If you want to play with it in the shell inside the Docker container, the run command is:

    docker run -it akb74/ts-jest-play

Alternatively, to pop it out of the container and play with it on your host system (and there's already a copy in this repo which you might have to delete first):

    docker create --name play-container akb74/ts-jest-play
    docker cp play-container:/ts-jest-play .

And to clean up afterwards:

    docker rm play-container

