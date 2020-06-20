INTRODUCTION
=
This project is an ultra-simple demonstration of using [RVS_Spinner](https://riftvalleysoftware.com/work/open-source-projects/#RVS_Spinner) as a standalone project, where we simply include the `RVS_Spinner.swift` file as a project file.

USAGE
=
The project is already set up. We have imported the [`RVS_Spinner.swift`]() file directly from the GitHub repo, and have added it to the `RVS_Spinner_Basic_Test_Harness` target.

We need to do a couple of things before running the target, however:

- We need to comment out the `import RVS_Spinner` in the main source file, because we are no longer using a sepatrate module:

    import UIKit
    // import RVS_Spinner

- We need to change the module for the spinner object in the Storyboard Editor file, by checking `Inherit Module From Target` in the Attributes Inspector. This is for the same reason as before.
 
Then build and run the `RVS_Spinner_Basic_Test_Harness` target.

LICENSE
=
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[The Great Rift Valley Software Company: https://riftvalleysoftware.com](https://riftvalleysoftware.com)
