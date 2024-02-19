module Debug
  module KernelExtension
    macro debug!(*args, **kwargs)
      {% unless kwargs.empty? %}
        ::Debug.log({{ args.splat }}, {{ kwargs.double_splat }})
      {% else %}
        ::Debug.log({{ args.splat }})
      {% end %}
    end
  end
end

include Debug::KernelExtension
