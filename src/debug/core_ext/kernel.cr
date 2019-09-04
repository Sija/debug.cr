module Debug
  module KernelExtension
    macro debug!(*args, **kwargs)
      {% unless kwargs.empty? %}
        ::Debug.log({{*args}}, {{**kwargs}})
      {% else %}
        ::Debug.log({{*args}})
      {% end %}
    end
  end
end

include Debug::KernelExtension
