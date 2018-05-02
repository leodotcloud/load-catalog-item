version: '2'
services:
  lb-for-load:
    image: rancher/lb-service-haproxy:v0.7.15
    ports:
    - 80:80/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin,agent
      io.rancher.container.agent_service.drain_provider: 'true'
      io.rancher.container.create_agent: 'true'
  global-load:
    image: leodotcloud/swiss-army-knife
    labels:
      io.rancher.scheduler.global: 'true'
  scaling-load:
    image: leodotcloud/swiss-army-knife
  curler:
    image: leodotcloud/swiss-army-knife
    links:
    - lb-for-load:lb
    command:
    - bash
    - -c
    - while true ; do curl -s lb | grep "Address" ; sleep 1 ; done
    labels:
      io.rancher.scheduler.global: 'true'
