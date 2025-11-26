FROM node:alpine3.22
RUN apk add jq
RUN apk add moreutils
RUN npm install --global strip-json-comments-cli

WORKDIR /ts-jest-play

# Setup package.json
RUN npm init --yes
RUN npm install -D typescript jest ts-jest @jest/globals

# Set up tests
RUN mkdir test
RUN echo "import {describe, it} from '@jest/globals'; describe('nothing', () => it('does nothing', () => {}))" > test/index.test.ts

# "Cannot use import statement outside of module."
# So setup jest.config.js
RUN npx ts-jest config:init

# The test run, but produce a warning. "you should consider setting 'esModuleInterop' to 'true'"
# So setup tsconfig.json
RUN npx tsc --init && strip-json-comments tsconfig.json | sponge tsconfig.json

# And set 'esModuleInterop' to 'true'
RUN jq '.compilerOptions.esModuleInterop=true' tsconfig.json | sponge tsconfig.json

# In index.test.js VSCode complains:
# "ECMAScript imports and exports cannot be written in a CommonJS file under 'verbatimModuleSyntax'"
# I don't care because my code will always be "bundled" either by jest or esbuild
# But I do care about VSCode reporting false positives, so:
RUN jq '.compilerOptions.module="ESNext"' tsconfig.json | sponge tsconfig.json
RUN jq '.compilerOptions.moduleResolution="bundler"' tsconfig.json | sponge tsconfig.json

# In tsconfig.json VSCode complains:
# "The compiler option "forceConsistentCasingInFileNames" should be enabled to reduce issues when working with different OSes."
# So:
RUN jq '.compilerOptions.forceConsistentCasingInFileNames=true' tsconfig.json | sponge tsconfig.json

# Done.  10 RUN commands.  Though maybe creating test/index.test.ts should count as more than one edit

# Run tests
RUN npx jest

# Remove node_modules for easy copying to host
RUN rm -rf node_modules

CMD ["sh"]
