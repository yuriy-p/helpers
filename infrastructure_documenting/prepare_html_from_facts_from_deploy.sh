rm -rf /tmp/facts
scp -r deploy.fabit.ru:/tmp/facts /tmp
ansible-cmdb /tmp/facts/ > ~/tasks/infrastructure_documenting/infrastructure_$(date +%Y-%m-%d).html
