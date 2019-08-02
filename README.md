
![Elephant by Emily Cutting & IV by ProSymbols from the Noun Project](images/evernote-doctor.png)

# Evernote Doctor

A bash script for basic enml note recovery - useful in case when evernote database 
corruption makes export impossible and local notebook recovery is necessary. This can 
be used when encountering the 'an internal database error has occurred' error that 
prevents evernote from opening in order to recover the content of local-only notebooks.

This script is designed using bash created and tested on osx '10.13.6' with Evernote 
version '7.9.1 (457700 direct)'. The script assumes a specific location in 
'Application Support' and searches there. Change that location in the script if it does 
not match where Evernote's enml files are for your installation.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

See LICENSE for more usage or restriction information.

# Usage

To use, run:

```
./recover-evernote-enml.sh > file.enex
```

then import the `file.enex` file into evernote. The recovered notes will have a random UUID title, 
and the export file should contain notes across all notebooks (online or local-only). The user will 
need to determine themselves (based on note content) which notes to recover once imported. Depending 
on number of notes an note sizes, this export process may take some time. Watch the 'file.enex' 
file (from above) which will continuously grow as the export runs.

NOTE: Follow Evernote's instructions for recovering the app functionality when its database is 
corrupted. This may be necessary before import is possible as a corrupted database may prevent 
Evernote from opening.

WARNING: Evernote's instructions may require deleting enml files this script uses to recover notes 
from. This script should be run before any destructive action is taken on Evernote files on disk. 
It is best to make a full backup of Evernote files before taking any destructive action on files.
This script can recover enml files from any location by configuring the `find_location` parameter 
in the script.

# Acknowledgements

[Elephant icon](https://thenounproject.com/search/?q=elephant&i=1742920) by Emily Cutting and 
[IV icon](https://thenounproject.com/search/?q=iv&i=529693) by ProSymbols from the 
[Noun Project](https://thenounproject.com/).
