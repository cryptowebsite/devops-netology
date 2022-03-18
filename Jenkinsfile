node("linux"){
    stage("Git checkout"){
        git branch: 'main', credentialsId: 'a9343f9a-4071-476b-b798-7fda404c0e64', url: 'git@github.com:cryptowebsite/elk.git'
        dir('roles/elastic') {
            git branch: 'master', credentialsId: 'a9343f9a-4071-476b-b798-7fda404c0e64', url: 'git@github.com:cryptowebsite/elastic-role.git'
        }
        dir('roles/filebeat') {
             git branch: 'master', credentialsId: 'a9343f9a-4071-476b-b798-7fda404c0e64', url: 'git@github.com:cryptowebsite/filebeat-role.git'
        }
        dir('roles/kibana') {
             git branch: 'master', credentialsId: 'a9343f9a-4071-476b-b798-7fda404c0e64', url: 'git@github.com:cryptowebsite/kibana-role.git'
        }
        dir('roles/logstash') {
             git branch: 'master', credentialsId: 'a9343f9a-4071-476b-b798-7fda404c0e64', url: 'git@github.com:cryptowebsite/logstash-role.git'
        }
    }
    stage("Sample define prod_run"){
        prod_run=true
    }
    stage("Run playbook"){
        if (prod_run){
            sh 'ansible-playbook site.yml -i inventory/prod.yml'
        }
        else{
            sh 'ansible-playbook site.yml -i inventory/prod.yml --check --diff'
        }
    }
}