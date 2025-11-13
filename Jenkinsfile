pipeline {
    agent any

    environment {
        IMAGE_NAME = "django-k8s-app"
        IMAGE_TAG = "latest"
        REGISTRY = "localhost"
        KUBE_CONFIG = "/home/vagrant/.kube/config"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "✅ GitHub에서 소스 코드 가져오는 중..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Docker 이미지 빌드 중..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Test Docker Image') {
            steps {
                echo "🧪 Docker 컨테이너 테스트 실행..."
                sh "docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} python3 manage.py check"
            }
        }

        stage('Push Image (Optional)') {
            steps {
                echo "📦 (옵션) Docker Hub 또는 로컬 레지스트리 푸시 단계"
                sh "echo '이미지를 외부로 푸시하려면 Docker Hub 로그인 후 활성화'"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 쿠버네티스에 배포 중..."
                sh """
                    export KUBECONFIG=${KUBE_CONFIG}
                    kubectl delete deployment django-deploy --ignore-not-found
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                """
            }
        }
    }

    post {
        success {
            echo "✅ 배포 성공! Django 앱이 Kubernetes에 반영되었습니다."
        }
        failure {
            echo "❌ 빌드 또는 배포 실패 — Jenkins 콘솔 로그 확인 필요."
        }
    }
}

