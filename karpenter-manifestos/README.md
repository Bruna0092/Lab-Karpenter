## NodePoll
Link: https://karpenter.sh/v1.0/concepts/nodepools/#spectemplatespecterminationgraceperiod

Basicamente aqui você irá definir as opções de provisionamento de nodes pelo Karpenter, como tipo de máquina, tamanhos, famílias e outros.

Neste laboratório utilizei as seguintes configurações:

Definições de Instance Types
```yaml
requirements:
    - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot"]
    - key: "karpenter.k8s.aws/instance-family"
        operator: In
        values: ["t3a", "t3", "m5"]
    - key: karpenter.k8s.aws/instance-size
        operator: In
        values: ["small", "medium", "large"]
    - key: "topology.kubernetes.io/zone"
        operator: In
        values: ["us-east-1a", "us-east-1b"]
```

Para o consolidation, que é a politica que deleta as instancias:
```yaml
disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 0s
```

Também vou aplicar esta label, que será utilizada para os deeployments das apps:
```yaml
template:
    metadata:
      labels:
        intent: apps
```

## NodeClass
Link: https://karpenter.sh/v1.0/concepts/nodeclasses/

No NodeClass você irá configurar reservas dos pods do sistema, seleção de AMI, role, subnets e outros. São opções mais voltadas as configurações da instancia.

Na configuração, adicionei uma reserva para os pods do sistema:
```yaml
kubelet:
    systemReserved:
      cpu: 100m
      memory: 100Mi
      ephemeral-storage: 1Gi
    kubeReserved:
      cpu: 200m
      memory: 100Mi
      ephemeral-storage: 3Gi
```

## Inflate

Um Pod que tem o objetivo apenas de testes, ele mantém o pod "vivo" até que o deployment seja deletado.

Aqui ele irá apenas criar os pods no node que contem a label "intent: apps":
```yaml
spec:
    nodeSelector:
        intent: apps
```
