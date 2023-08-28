echo '开始部署'
hexo g && hexo d
echo '博客部署完成'
git add .
# 获取当前时间作为commit message
deploy_date=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "Site updated: $deploy_date"
git push origin hexo:hexo
echo '代码提交完成'