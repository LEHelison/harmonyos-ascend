export const createChatCompletion = async ({
  model,
  messages,
  temperature = 0.7,
  max_tokens = 512,
  apiKey
}) => {
  const options = {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model,
      messages,
      stream: false,
      max_tokens,
      stop: null,
      temperature,
      top_p: 0.7,
      top_k: 50,
      frequency_penalty: 0.5,
      n: 1,
      response_format: { type: 'text' },
      tools: [{
        type: 'function',
        function: {
          description: '',
          name: '',
          parameters: {},
          strict: false
        }
      }]
    })
  };

  try {
    const response = await fetch('http://192.168.31.11:5001/api/query', options);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('API call failed:', error);
    throw error;
  }
}; 