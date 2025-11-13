pipeline {
    agent any

    environment {
        IMAGE_NAME = "chlwjddn/django-k8s-app"
        IMAGE_TAG = "latest"
        KUBE_CONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "✅ GitHub에서 소스 코드 가져오는 중..."
                checkout scm
            }
        }

        stage('Docker Login') {
            steps {
                echo "🔐 Docker Hub 로그인 중..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Docker 이미지 빌드 중..."
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Test Docker Image') {
            steps {
                echo "🧪 Docker 컨테이너 테스트 실행..."
                sh """
                    docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} python3 manage.py check
                """
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo "📦 Docker Hub로 이미지 Push..."
                sh """
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 쿠버네티스에 배포 중..."
                sh """
                    export KUBECONFIG=${KUBE_CONFIG}
                    kubectl delete deployment django-deploy --ignore-not-found
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/deployment-django.yaml
                    kubectl apply -f k8s/service-django.yaml
                """
            }
        }
    }

    post {
        success {
            echo "🎉 배포 성공! Django 앱이 Kubernetes에 반영되었습니다."
        }
        failure {
            echo "❌ 빌드 또는 배포 실패 — Jenkins 콘솔 로그 확인 필요."
        }
    }
}

