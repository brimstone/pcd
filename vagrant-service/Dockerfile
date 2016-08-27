FROM busybox

COPY sshfront /usr/bin/sshfront

COPY handler /usr/bin/handler

ENTRYPOINT ["/usr/bin/sshfront"]

CMD ["/usr/bin/handler"]
