# Hyperledger Besu 노드 구성

이 프로젝트는 Hyperledger Besu를 사용하여 3개의 노드로 구성된 프라이빗 블록체인 네트워크를 설정하는 방법을 제공합니다.

## 구성 개요

- **Node 1**: RPC 포트 8545, P2P 포트 30303
- **Node 2**: RPC 포트 8555, P2P 포트 30304  
- **Node 3**: RPC 포트 8565, P2P 포트 30305

## 사전 요구사항

1. **Java 17 이상** 설치 (OpenJDK 17 권장)
2. **Hyperledger Besu** 설치 및 PATH 설정
3. **Ubuntu Linux 환경** (bash 스크립트 사용)

## 설치 방법

### 1. 자동 설치 (권장)

```bash
# 설치 스크립트 실행
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

### 2. 수동 설치

```bash
# Java 17 설치
sudo apt-get update
sudo apt-get install openjdk-17-jdk

# Besu 다운로드 및 설치
wget https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/23.10.1/besu-23.10.1.tar.gz
tar -xzf besu-23.10.1.tar.gz
export PATH=$PWD/besu-23.10.1/bin:$PATH
```

### 2. 프로젝트 설정

```bash
# 프로젝트 클론 또는 다운로드
git clone <repository-url>
cd hyperledger-config
```

## 사용 방법

### 개별 노드 시작

```bash
# Node 1 시작
./start-node1.sh

# Node 2 시작  
./start-node2.sh

# Node 3 시작
./start-node3.sh
```

### 모든 노드 한 번에 시작

```bash
./start-all-nodes.sh
```

## 네트워크 구성

### 포트 구성

| 노드 | RPC HTTP | RPC WS | P2P | Metrics |
|------|----------|---------|-----|---------|
| Node 1 | 8545 | 8546 | 30303 | 9545 |
| Node 2 | 8555 | 8556 | 30304 | 9555 |
| Node 3 | 8565 | 8566 | 30305 | 9565 |

### 네트워크 설정

- **Chain ID**: 1337
- **Consensus**: Clique (PoA)
- **Block Period**: 15초
- **Epoch Length**: 30000 블록

## 노드 연결

노드들이 서로 연결되도록 하려면:

1. 첫 번째 노드를 시작하고 enode URL을 확인
2. 다른 노드들의 `besu-node*.toml` 파일에서 `bootnodes` 설정을 업데이트
3. 나머지 노드들을 시작

### enode URL 확인 방법

```bash
# Node 1에서 enode URL 확인
curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://localhost:8545

# 또는 스크립트 사용
./check-status.sh
```

## 모니터링

### 로그 확인

각 노드의 로그는 `logs/` 디렉토리에 저장됩니다:

```bash
# 실시간 로그 확인
tail -f logs/node1.log
tail -f logs/node2.log
tail -f logs/node3.log

# 또는 스크립트 사용
./check-status.sh
```

### 메트릭스

각 노드의 메트릭스는 다음 포트에서 확인 가능:
- Node 1: http://localhost:9545
- Node 2: http://localhost:9555  
- Node 3: http://localhost:9565

### RPC 엔드포인트 테스트

```bash
# Node 1 연결 테스트
curl -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}' http://localhost:8545

# Node 2 연결 테스트
curl -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}' http://localhost:8555

# Node 3 연결 테스트
curl -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}' http://localhost:8565
```

## 문제 해결

### 일반적인 문제들

1. **포트 충돌**: 다른 서비스가 같은 포트를 사용하고 있는지 확인
2. **권한 문제**: 스크립트 실행 권한 확인 (`chmod +x *.sh`)
3. **Besu 미설치**: PATH에 Besu가 올바르게 설정되었는지 확인
4. **Java 버전**: Java 17 이상이 설치되어 있는지 확인

### 로그 분석

각 노드의 로그에서 다음을 확인:
- P2P 연결 상태
- 동기화 진행 상황
- 에러 메시지

## 고급 설정

### 마이닝 활성화

특정 노드에서 마이닝을 활성화하려면 해당 `besu-node*.toml` 파일에서:

```toml
miner-enabled=true
miner-coinbase="YOUR_ADDRESS_HERE"
```

### 프라이버시 기능

프라이버시 기능을 활성화하려면:

```toml
privacy-enabled=true
privacy-url="http://localhost:8888"
```


## 추가 스크립트

- `install-ubuntu.sh`: Ubuntu 환경에서 Besu와 의존성 자동 설치
- `check-status.sh`: 모든 노드의 상태 및 연결 상태 확인
- `stop-all-nodes.sh`: 모든 노드 중지
- `start-docker.sh`: Docker Compose를 사용한 노드 실행

## 지원

문제가 발생하거나 질문이 있으시면 이슈를 생성해 주세요.
