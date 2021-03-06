{{- define "docker_volumes" -}}
- name: cgroup
  hostPath:
    path: "/sys/fs/cgroup"
- name: runc
  hostPath:
    path: "/run/runc"
- name: dockerrootdir
  hostPath:
    path: "/var/lib/docker/containers"
- name: dockersock
  hostPath:
    path: "/var/run/docker.sock"
{{- end -}}

{{- define "docker_volume_mounts" -}}
- name: cgroup
  mountPath: "/sys/fs/cgroup"
- name: runc
  mountPath: "/run/runc"
- name: dockersock
  mountPath: "/var/run/docker.sock"
- name: dockerrootdir
  mountPath: "/containers"
{{- end -}}

{{- define "docker_pull_runtimes" -}}
- name: docker-pull-runtimes
  imagePullPolicy: {{ .Values.invoker.imagePullPolicy | quote }}
  image: {{ .Values.invoker.pullRuntimesImage | quote }}
  volumeMounts:
  - name: dockersock
    mountPath: "/var/run/docker.sock"
  env:
    # action runtimes
    - name: "RUNTIMES_MANIFEST"
      value: {{ template "runtimes_manifest" . }}
    - name: "DOCKER_REGISTRY"
      value: {{ .Values.docker.registry.name | quote }}
    - name: "DOCKER_IMAGE_PREFIX"
      value: {{ .Values.docker.image.prefix | quote }}
    - name: "DOCKER_IMAGE_TAG"
      value: {{ .Values.docker.image.tag | quote }}
    - name: "DOCKER_REGISTRY_USERNAME"
      valueFrom:
        secretKeyRef:
          name: docker.registry.auth
          key: docker_registry_username
    - name: "DOCKER_REGISTRY_PASSWORD"
      valueFrom:
        secretKeyRef:
          name: docker.registry.auth
          key: docker_registry_password
{{- end -}}

