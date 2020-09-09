# Heroku-AriaNG-21vianet. Heroku-AriaNG 世纪互联版
Build AriaNG on Heroku, and upload to cloud drive when the file download completed.<br>
在 Heroku 上搭建 AriaNG ，并在文件下载完成后上传至网盘。

Using Rclone with 21vianet mod and Aria2, even UNRAR online flexibly? Try this [Heroku Rclone 21vianet](https://github.com/xinxin8816/heroku-rclone-21vianet)<br>
想更灵活的使用 Aria2、Rclone，甚至是 RAR 在线解压？试试这个 [Heroku Rclone 世纪互联版](https://github.com/xinxin8816/heroku-rclone-21vianet)

## Abuse Warning 滥用警告

**This APP designed for best performance so uses a lot of resources.**<br>
**本应用为最佳性能设计而使用大量资源。**

**Please be careful with that your Heroku account may be suspend.**<br>
**请注意长时间占用资源可能会导致封号。**

## Improvement 改进

1. Rclone with 21vianet patch and Gclone mod. 融合了世纪互联补丁和 Gclone 模组的 Rclone。
2. Support mount double cloud drive. 支持双网盘挂载同步。
3. Improve performance of the built-in Aria2c and Rclone. 大幅提升内置 Aria2c 和 Rclone 性能。
4. Fix some little issues in fork source. 修复项目源的一些其他小问题。

## Deploy by Docker (Recommend)

FAQ: [Do I have to use Docker?](#do-i-have-to-use-docker)

### Requirement 要求

* [Docker](https://www.docker.com/)
* [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
* [git](https://git-scm.com/)
* Ability to use terminal

### Steps 步骤

1. Run `heroku login` to login, then `heroku container:login` too.
2. Clone this repository and enter it. (PS: Please run `git config --global core.autocrlf false` before `git clone` if you are using Windows.)
3. Run `heroku apps:create APP_NAME` to create it.
4. Run `heroku config:set -a APP_NAME ARIA2C_SECRET=ARIA2_SECRET` and `heroku config:set -a APP_NAME HEROKU_APP_NAME=APP_NAME`.
5. Run `heroku container:push web -a APP_NAME` and `heroku container:release web -a APP_NAME`.
6. Run `heroku open -a APP_NAME` and it will open your browser to deployed instance. 

## Deploy by One-Click

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

**Pay attention please: deploy by One-Click button uses the Heroku built-in environment, that means your account might banned immediately.**

**请注意：一键部署使用 Heroku 内置环境，可能会导致立即被封号**

## Optional: Connect Cloud Drive With Rclone 连接网盘

1. Setup Rclone by following [Rclone Docs](https://rclone.org/docs/), Chinese users can setup with 21vianet patch to connect OneDrive by 21vianet.<br> 
You can find your config from there:

```
Windows: %userprofile%\.config\rclone\rclone.conf
Linux: $HOME/.config/rclone/rclone.conf
```
Optional: Using service account setup with [Gclone](https://github.com/donwa/gclone) to break Google Drive 750GB limit, or easier connect to folder or Team Drive by destination ID. 

if you deploying by Docker:<br>
Create a new folder in your local repository root path after git clone, such as `/accounts/`, copy your SA json in it. Open rclone config and edit `service_account_file_path = /app/accounts/` as the json paths.

if you deploying by One-Click:<br>
Fork this repository, and create a new folder in your forked repository, such as `/accounts/`, upload your SA json in it. Open rclone config and edit `service_account_file_path = /app/accounts/` as the json paths.

2. Your `rclone.conf` file, it should look like this:

```conf
[DRIVENAME A]
type = WHATEVER
client_id = WHATEVER
client_secret = WHATEVER
scope = WHATEVER
china_version = WHATEVER
token = WHATEVER

[DRIVENAME B]
type = WHATEVER
client_id = WHATEVER
client_secret = WHATEVER
scope = WHATEVER
china_version = WHATEVER
token = WHATEVER

others entries...
```

3. Find the drive you want to use, and copy its `[DRIVENAME A] ...` to  `... token = ...` section, and replace all linebreaks with `\n`.
4. Set Rclone Config:

if you deploying by Docker:<br>
Run `heroku config:set -a APP_NAME RCLONE_CONFIG=THAT_TEXT`.

if you deploying by One-Click:<br>
Paste that text in `RCLONE_CONFIG`.

5. Set Rclone Upload Destination:

if you deploying by Docker:<br>
Run `heroku config:set -a APP_NAME RCLONE_DESTINATION=DOWNLOAD_DESTINATION`, `DOWNLOAD_DESTINATION` is a path starting with `/`.

if you deploying by One-Click:<br>
Set `RCLONE_DESTINATION` to a path you want to store your downloaded in `[DRIVENAME A]`, format is `[DRIVENAME A]:[REMOVE PATH A]`

7. If you mount a second cloud drive, Set `RCLONE_DESTINATION_2` same as step 6.

## FAQ 常见问题

### Do I have to use Docker?
Not really, if you deployed previously and the APP is still working well, please enjoy it just like before.

If you want to deploy a new APP or rebuild the previously APP, I recommend using Docker to prevent account banned.

### Why it automatically stop after 30 minutes, and files were lost?
Heroku Free Dyno will idle when there is no incoming request within 30 minutes, and your files will be deleted, so use Rclone to breaking this or use Heroku Hobby Dyno.

By the way, the use of memory exceeds the limit of 512M for a long time, Heroku dyno also will idle.

### Why it still stop after 24 hours when i have used rclone?
Heroku-AriaNG APP will automatically make request to prevent idling when connect cloud drive with Rclone, but Heroku Dyno reset every 24 hours is inevitable.

### How to view upload process?
Go to Heroku Dashboard, and view application logs.

### How to edit rclone or aria2c config?
Open `on-complete.sh` and `aria2c.conf`, some global variables that can be edit, but believe me, the best parameters for best performance have been provided.

### How to delete files?
The file will be automatically deleted after the upload is complete. you can also delete the file by deleting the aria2 task.

### Can you provide more detailed configuration and deployment instructions
Nope. This README is enough.

## Thanks
Many thanks for maple3142/heroku-aria2c and P3TERX/aria2.conf.
